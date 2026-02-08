extends Node3D

@onready var path_3d: Path3D = $Armature/Skeleton3D/BoneAttachment3D/Path3D
@onready var end_body: RigidBody3D = $PinJoint3D/EndBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path_3d.curve.set_point_position(1, end_body.global_position)
