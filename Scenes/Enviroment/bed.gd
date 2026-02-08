extends Node3D

var evil := false
var morph := false
var player: CharacterBody3D = null

@onready var target_pos: Marker3D = $TargetPos
@onready var legs: MeshInstance3D = $"Bed Physic/Legs"
@onready var pillow: MeshInstance3D = $"Bed Physic/Pillow"

@onready var bed_physic: RigidBody3D = $"Bed Physic"
@onready var bed: Node3D = $"."


var leg_offset
var pillow_offset 
var attack = false
var attack_loop = false
var target_velocity := Vector3(0.0, 0.0, 0.0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if evil:
		global_position.y = move_toward(global_position.y, target_pos.global_position.y, delta * 2.0)

		rotation.y = move_toward(rotation.y, deg_to_rad(0), delta * 2.0)
		rotation.x = move_toward(rotation.x, deg_to_rad(90), delta * 2.0)
		if global_position.distance_to(target_pos.global_position) < 0.1:
			leg_offset = legs.position.y + 0.49
			pillow_offset = pillow.position.z - 0.69
			evil = false
			morph = true
	
	if morph:
		
		legs.position.y = move_toward(legs.position.y, 0.49, delta * 2.0)
		pillow.position.z = move_toward(pillow.position.z, -0.69, delta * 2.0)
		print(pillow.position.z, legs.position.y)
		
		if pillow.position.z >= -0.65 and legs.position.y >= 0.47:
			attack = true
			#bed_physic.top_level = true
			#attack_calculation()
	
	if attack:
		
		
			
		#print(target_velocity)
		#bed_physic.apply_central_force(target_velocity * 3.0)
		global_position = global_position.lerp(player.global_position, delta * 3.0)
		

func _on_area_3d_body_entered(body: Node3D) -> void:
	evil = true
	if body is CharacterBody3D:
		player = body


@onready var upgrades: Control = $"../../../../../Shop/Upgrades"


func attack_calculation():
	target_velocity = Vector3(randf_range(-2.0, 2.0),
							 0.0, 
							randf_range(-2.0, 2.0)).normalized()
	
	await get_tree().create_timer(4.0).timeout
	
	target_velocity = Vector3(0.0, 0.0, 0.0)
	
	await get_tree().create_timer(2.0).timeout
	
	attack_calculation()


func _on_death_body_entered(body: Node3D) -> void:
	body.die()
	upgrades.game_over.emit()
	bed.queue_free()
