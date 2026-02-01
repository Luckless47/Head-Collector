extends Node3D

@onready var player: CharacterBody3D = $Player
var day_length = 10
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var spot_light: SpotLight3D = $SpotLight3D
@onready var money_label: Label = $Shop/MoneyCounter/MoneyLabel
@onready var player_money_label: Label = $Player/MoneyCounter/MoneyLabel
@onready var shop: Control = $Shop
@onready var projectiles: Node3D = $Player/Camera3D/Glock/Projectiles
@onready var enemy_pool: Node3D = $EnemyPool
@onready var player_spawn_pos: Marker3D = $PlayerSpawnPos
const ENEMY_POOL = preload("uid://1a8km6ncqc77")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_loop()
	player.enter_shop.connect(_enter_shop)
	shop.exit_shop.connect(_exit_shop)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enter_shop():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	player.ray_cast.enabled = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player.money_label.modulate.a = 0.0
	money_label.text = "$%d" % player.money
	
	shop.show()
	
func day_loop():
	player.global_position = player_spawn_pos.global_position
	for enemy in enemy_pool.get_children():
		if enemy is CharacterBody3D:
			enemy.call_deferred("queue_free")
			

	for projectile in projectiles.get_children():
		if projectile is Bullet:
			projectile.queue_free()
	
	
	enemy_pool.queue_free()
	enemy_pool = ENEMY_POOL.instantiate()
	add_child(enemy_pool)
	enemy_pool.global_position = Vector3(0.77, 1.4, 3.14)
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
	shop.hide()
	day_loop()
