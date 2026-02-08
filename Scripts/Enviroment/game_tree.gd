extends Node3D


var day_length := 2
var money_value := 2
var spawn_rate := 5

@onready var screen: MeshInstance3D = $SubViewportContainer/SubViewport/Bed/computer/Desk/Computer/Screen

@onready var spot_light: SpotLight3D = $SubViewportContainer/SubViewport/SpotLight

@onready var shop_money_label: Label = $Shop/MoneyCounter/MoneyLabel

const SCOOPER = preload("uid://b8d2cnopd8pma")

@onready var world_environment: WorldEnvironment = $SubViewportContainer/SubViewport/WorldEnvironment

@onready var shop: Control = $Shop


@onready var area_trip: Area3D = $SubViewportContainer/SubViewport/Enviroment/Ground/Hole/AreaTrip

var player_money_label
var player_projectiles
@onready var enemy_pool: Node3D = $SubViewportContainer/SubViewport/EnemyPool
@onready var player_spawn_pos: Marker3D = $SubViewportContainer/SubViewport/PlayerSpawnPos
@onready var scooper_pool: Node3D = $SubViewportContainer/SubViewport/ScooperPool

const PLAYER = preload("uid://de7udajy6v357")
const ENEMY_POOL = preload("uid://1a8km6ncqc77")
@onready var vhs_effect: CanvasLayer = $VHSEffect

@onready var menu: Control = $Menu
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

var player: CharacterBody3D = null
signal player_spawned(player)
signal scooper_spawned(scooper)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	menu.start_pressed.connect(_start)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _start():
	player = PLAYER.instantiate()
	sub_viewport.add_child(player)
	
	player_money_label = player.money_label
	player_projectiles = player.projectiles
	player.enter_shop.connect(_enter_shop)
	
	player_spawned.emit(player)
	
	shop.exit_shop.connect(_exit_shop)
	
	menu.hide()
	
	day_loop()

@onready var crt_startup: AudioStreamPlayer = $Shop/Upgrades/CRT_Startup

@onready var background: Control = $Shop/Background


func _enter_shop():
	if !get_tree().paused:
		get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	player.ray_cast.enabled = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.money_label.modulate.a = 0.0
	player.money = roundi(float(player.money) * player.multiplier)
	shop_money_label.text = "$%d" % player.money
	
	vhs_effect.show()
	
	shop.do_start_animation()
	
	#await get_tree().create_timer(2).timeout
	#night_music.play()
	
	
func day_loop():
	player.global_position = player_spawn_pos.global_position
	player.multiplier = 1.0
	var scooper_count = scooper_pool.get_child_count()
	
	for enemy in enemy_pool.get_children():
		if enemy is CharacterBody3D:
			enemy.call_deferred("queue_free")
			
	for scooper in scooper_pool.get_children():
		scooper.queue_free()
			

	for projectile in player_projectiles.get_children():
		if projectile is Bullet:
			projectile.queue_free()
	
	
	for i in range(scooper_count):
		var scooper = SCOOPER.instantiate()
		scooper_pool.add_child(scooper)
		
		scooper.global_position = scooper_pool.global_position + Vector3(0, 0, 2*i)
		scooper_spawned.emit(scooper)
		
		
	enemy_pool.queue_free()
	enemy_pool = ENEMY_POOL.instantiate()
	add_child(enemy_pool)
	enemy_pool.global_position = Vector3(0.77, 1.4, 3.14)
	enemy_pool.money_value = money_value
	enemy_pool.spawn_rate = spawn_rate
	enemy_pool.can_spawn = true
	enemy_pool.player = player
	enemy_pool.spawn_loop()
	
	player.can_pickup = true
	get_tree().paused = false
	
	await get_tree().create_timer(day_length).timeout
	player.flash_light.light_energy = 0.1
	var material: StandardMaterial3D = screen.mesh.surface_get_material(0)
	material.emission_enabled = true
	screen.mesh.surface_set_material(0, material)
	world_environment.environment.background_energy_multiplier = 0.0
	spot_light.light_energy = 1.0
	player.can_sleep = true
	player.can_pickup = false
	get_tree().paused = true

func _exit_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.ray_cast.enabled = true
	player.process_mode = Node.PROCESS_MODE_ALWAYS
	spot_light.light_energy = 0.0
	player.flash_light.light_energy = 0.0
	world_environment.environment.background_energy_multiplier = 1.0
	
	var material: StandardMaterial3D = screen.mesh.surface_get_material(0)
	material.emission_enabled = false
	screen.mesh.surface_set_material(0, material)
	
	
	player.can_sleep = false
	
	
	shop.do_stop_animation()
	
	day_loop()
