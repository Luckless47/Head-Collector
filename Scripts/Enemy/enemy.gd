extends CharacterBody3D


const SPEED = 2.0
const JUMP_VELOCITY = 4.5

var can_walk = false
var direction

@onready var head: RigidBody3D = $Head
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal spawned

func _ready() -> void:
	await spawned
	head.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
	head.add_to_group("body_part")
	start_walk_loop()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_walk:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
		velocity = direction * SPEED
		#for i in get_slide_collision_count():
			#var collider = get_slide_collision(i)
			#print(collider)
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")
		velocity.x = move_toward(velocity.x, 0.0, delta)
		velocity.z = move_toward(velocity.z, 0.0, delta)
	
	
	

	move_and_slide()

func start_walk_loop():
	can_walk = true
	direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0))
	await get_tree().create_timer(2.0).timeout
	can_walk = false
	await get_tree().create_timer(2.0).timeout
	start_walk_loop()


		
