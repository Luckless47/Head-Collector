extends RigidBody3D

class_name Bullet

var is_lethal := true
var despawn := false

@onready var fireball_head_mesh: MeshInstance3D = $VFX_Fireball/FireballHeadMesh
@onready var fireball_mesh: MeshInstance3D = $VFX_Fireball/FireballMesh


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	print(linear_velocity.length())
	if linear_velocity.length() <= 1:
		is_lethal = false
	else:
		is_lethal = true
	


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if is_lethal:
		if body.get_collision_layer_value(3):
			if body is RigidBody3D:
				var body_part: RigidBody3D = body
				
				body_part.simulate_impact.emit(-basis.z, null)
			elif body is PhysicalBone3D:
				var bone: PhysicalBone3D = body
				bone.simulate_impact.emit(-basis.z, bone)
		
		#elif body is CharacterBody3D:
			#body._simulate_impact(global_position, null)

		
		
		
