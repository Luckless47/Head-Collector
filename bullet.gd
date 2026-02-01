extends RigidBody3D

class_name Bullet


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print(body)
	if body.is_in_group("body_part"):
		var body_part: RigidBody3D = body
		
		body_part.freeze = false
		body_part.top_level = true
		
		
		await get_tree().process_frame
		
		var direction = global_position.direction_to(body_part.global_position)
		body_part.apply_central_impulse(direction * 30.0)
		
