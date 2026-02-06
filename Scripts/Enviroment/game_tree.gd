extends Node3D


var day_length := 60
var money_value := 2
var spawn_rate := 5


@onready var spot_light: SpotLight3D = $SubViewportContainer/SubViewport/SpotLight

@onready var money_label: Label = $Shop/MoneyCounter/MoneyLabel


@onready var world_environment: WorldEnvironment = $SubViewportContainer/SubViewport/WorldEnvironment

@onready var shop: Control = $Shop

var player_money_label
var player_projectiles
@onready var enemy_pool: Node3D = $SubViewportContainer/SubViewport/EnemyPool
@onready var player_spawn_pos: Marker3D = $SubViewportContainer/SubViewport/PlayerSpawnPos

const PLAYER = preload("uid://de7udajy6v357")
const ENEMY_POOL = preload("uid://1a8km6ncqc77")
@onready var vhs_effect: CanvasLayer = $VHSEffect

@onready var menu: Control = $Menu
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

var player: CharacterBody3D = null
signal player_spawned
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


func _enter_shop():
	if !get_tree().paused:
		get_tree().paused = true
		
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	player.ray_cast.enabled = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.money_label.modulate.a = 0.0
	money_label.text = "$%d" % player.money
	
	shop.show()
	vhs_effect.show()
	
func day_loop():
	player.global_position = player_spawn_pos.global_position
	for enemy in enemy_pool.get_children():
		if enemy is CharacterBody3D:
			enemy.call_deferred("queue_free")
			

	for projectile in player_projectiles.get_children():
		if projectile is Bullet:
			projectile.queue_free()
	
	
	enemy_pool.queue_free()
	enemy_pool = ENEMY_POOL.instantiate()
	add_child(enemy_pool)
	enemy_pool.global_position = Vector3(0.77, 1.4, 3.14)
	enemy_pool.money_value = money_value
	enemy_pool.spawn_rate = spawn_rate
	enemy_pool.can_spawn = true
	enemy_pool.spawn_loop()
	
	player.can_pickup = true
	get_tree().paused = false
	
	await get_tree().create_timer(day_length).timeout
	player.flash_light.light_energy = 0.1
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
	player.can_sleep = false
	vhs_effect.hide()
	shop.hide()
	day_loop()
