extends RigidBody3D


signal add_money



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if global_position.y < -7.0:
		add_money.emit(1)
		queue_free()
