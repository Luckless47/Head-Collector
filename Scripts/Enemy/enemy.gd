extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5

var can_walk = false
var direction: Vector3 = Vector3()

@onready var head: RigidBody3D = $Head

@onready var armature: Node3D = $Armature
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var footstep_audio: AudioStreamPlayer3D = $FootstepAudio
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


signal spawned

func _ready() -> void:
	await spawned
	head.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
	head.add_to_group("body_part")
	head.simulate_impact.connect(_simulate_impact)
	for bone in armature.physical_bone_simulator.get_children():
		bone.simulate_impact.connect(_simulate_impact)
	start_walk_loop()

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_walk:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
		
		if !footstep_audio.playing:
			footstep_audio.play()
		
		if is_on_wall():
			var wall_normal = get_wall_normal()
			direction = direction.bounce(wall_normal).normalized()
		
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var flat_vel = Vector3(velocity.x, 0, velocity.z)
		
		if flat_vel.length_squared() > 0.001:
			var target_yaw = atan2(flat_vel.x, flat_vel.z)
			rotation.y = lerp_angle(rotation.y, target_yaw, delta * 6.0)
		

		#for i in get_slide_collision_count():
			#var collider = get_slide_collision(i)
			#print(collider)
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")
		velocity.x = 0.0
		velocity.z = 0.0
	
	
	

	move_and_slide()

func start_walk_loop():
	can_walk = true
	direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	await get_tree().create_timer(2.0).timeout
	can_walk = false
	await get_tree().create_timer(2.0).timeout
	start_walk_loop()


func _simulate_impact(projectile_pos, bone):
		head.freeze = false
		head.top_level = true
		
		
		await get_tree().process_frame
		
		#var throw_direction = projectile_pos.direction_to(head.global_position)
		
		
		collision_shape.disabled = false
		armature.physical_bone_simulator.physical_bones_start_simulation()
		
		if bone:
			bone.apply_central_impulse(projectile_pos * 5.0)
			
		else:
			head.apply_central_impulse(projectile_pos * 5.0)
		
