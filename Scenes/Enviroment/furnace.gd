extends Node3D

var cremating := false
@onready var burn_pit: Marker3D = $BurnPit

var current_body_bone: PhysicalBone3D
var player: CharacterBody3D = null

@onready var game_tree: Node3D = $"../../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_tree.player_spawned.connect(_on_player_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if conveying and not cremating and current_body_bone:
		var target_pos = burn_pit.global_position
		var to_target = target_pos - current_body_bone.global_position
		current_body_bone.linear_velocity = to_target * 2.0
		




func _on_player_spawn(_player):
	player = _player


var conveying
func _on_tray_area_body_entered(body: Node3D) -> void:
	if body is PhysicalBone3D:
		if not conveying and not cremating:
			current_body_bone = body
			
			if player.picking_up:
				player.drop_item()
			
			conveying = true
			
			
			
			
			

@onready var door: MeshInstance3D = $Furnace/Door

		
func burn_enemy(body):
		
		await get_tree().create_timer(2.0).timeout
		
		
		var enemy =  body.get_parent().get_parent().get_parent().get_parent()
		
		enemy.queue_free()
		
		burn_sound.play()
		

@onready var burn_sound: AudioStreamPlayer3D = $BurnSound


func _on_burn_pit_area_body_entered(body: Node3D) -> void:
	if not cremating:
		cremating = true
		
		var tween = create_tween()
		tween.tween_property(door, "rotation:y", deg_to_rad(-140.0), 1.0)
		tween.tween_callback(burn_enemy.bind(body))
		tween.tween_property(door, "rotation:y", deg_to_rad(-20.0), 1.0).set_delay(5.0)
		
		await tween.finished

		player.add_multiplier()
		cremating = false
		conveying = false
