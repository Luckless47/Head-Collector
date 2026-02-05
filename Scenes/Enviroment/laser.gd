extends Node3D


@onready var ray_cast: RayCast3D = $RayCast3D
@onready var scalar: Node3D = $Scalar



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast.is_colliding():
		var point = ray_cast.get_collision_point()
		var origin = ray_cast.global_transform.origin
		var distance = origin.distance_to(point)
		
		scalar.scale.z = distance
		scalar.position.z = -distance/2
	else:
		scalar.scale.y = ray_cast.target_position.z
		scalar.position.z = -ray_cast.target_position.z / 2
