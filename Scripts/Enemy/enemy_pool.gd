extends Node3D


var spawn_rate := 5
const ENEMY = preload("uid://2oqfqxx5b61g")
@onready var enemy_spawn_pos: Marker3D = $EnemySpawnPos
var can_spawn := false
var money_value := 2
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.


func spawn_loop():
	var enemy: CharacterBody3D = ENEMY.instantiate()
	add_child(enemy)
	if enemy:
		enemy.scale = Vector3(0.1, 0.1, 0.1)
		enemy.global_position = enemy_spawn_pos.global_position
		print(money_value)
		enemy.money_value = money_value
		enemy.player = player
		var tween = create_tween()
		#tween.set_parallel(true)
		tween.tween_property(enemy, "scale", Vector3(1.0, 1.0, 1.0), spawn_rate)
		#tween.tween_property(enemy, "head:scale", Vector3(1.0, 1.0, 1.0), spawn_rate)
		await tween.finished
		if enemy:
			enemy.spawned.emit()
		await get_tree().create_timer(0.1).timeout
	if can_spawn:
		spawn_loop()



	
