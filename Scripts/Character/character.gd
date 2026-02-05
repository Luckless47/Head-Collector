extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var headbob_time := 0.0
@export var headbob_frequency = 2.0
@export var headbob_amplitude = 0.04

var footstep_can_play := true
var footstep_landed

var pickable_obj: RigidBody3D = null
var can_sleep := false

var money = 120

var can_pickup := true

@onready var footstep_audio: AudioStreamPlayer3D = $FootstepAudio
@onready var money_label: Label = $MoneyCounter/MoneyLabel
@onready var flash_light: SpotLight3D = $Camera3D/FlashLight

signal enter_shop

signal remove_money

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	remove_money.connect(_remove_money)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (camera.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	

	move_and_slide()
	
	
		
	
	
	camera_rotate()
	
	headbob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = headbob(headbob_time)
	
	if not footstep_landed and is_on_floor():
		footstep_audio.play()
	elif footstep_landed and not is_on_floor():
		footstep_audio.play()
	footstep_landed = is_on_floor()
	
	
	if ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("body_part") and can_pickup:
		pickable_obj = ray_cast.get_collider()
		if Input.is_action_just_pressed("pickup") and !pickable_obj.freeze and !picking_up:
			picking_up = true
			pickable_obj.gravity_scale = 0.0
			if !pickable_obj.add_money.is_connected(_add_money):
				pickable_obj.add_money.connect(_add_money)
		
	elif ray_cast.is_colliding() and ray_cast.get_collider().is_in_group("bed"):
		print("sleep")
		if Input.is_action_just_pressed("pickup") and can_sleep:
			sleep()
	
	if picking_up and pickable_obj:
		var target_pos = pickup_pos.global_position
		var to_target = target_pos - pickable_obj.global_position
		
		pickable_obj.linear_velocity = to_target * 10.0
		#pickable_obj.linear_velocity = pickable_obj.linear_velocity.clamp(
			#Vector3(0.0, 0.0, 0.0), Vector3(5.0, 5.0, 5.0))
	
			
		
	
var picking_up = false

@onready var pickup_pos: Marker3D = $Camera3D/PickupPos
#@onready var shop: Control = $"../Shop"

func sleep():
	enter_shop.emit()

	

func camera_rotate():
	camera.rotation.y = yaw
	camera.rotation.x = pitch
	
	
func headbob(headbob_time):
	var headbob_position = Vector3.ZERO
	headbob_position.y = sin(headbob_time * headbob_frequency) * headbob_amplitude
	headbob_position.x = cos(headbob_time * headbob_frequency / 2) * headbob_amplitude
	
	var footstep_threshold = -headbob_amplitude * 0.002
	if headbob_position.y > footstep_threshold:
		footstep_can_play = true
	elif headbob_position.y < footstep_threshold and footstep_can_play:
		footstep_can_play = false
		footstep_audio.play()
	
	return headbob_position

var yaw = 0.0
var pitch = 0.0
var SENS = 0.003

@onready var camera: Camera3D = $Camera3D

@onready var animation_tree: AnimationTree = $Camera3D/Sway/Idle/Glock/AnimationTree
@onready var projectiles: Node3D = $Camera3D/Sway/Idle/Glock/Projectiles
@onready var bullet_spawn_pos: Marker3D = $Camera3D/Sway/Idle/Glock/BulletSpawnPos
@onready var glock_sound: AudioStreamPlayer3D = $Camera3D/Sway/Idle/Glock/GlockSound

var fire_rate = 2.0

const BULLET = preload("uid://ctp0o18g7yp8p")

var can_shoot = true
var attack_buffered = false

@onready var ray_cast: RayCast3D = $Camera3D/RayCast3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# move our mouse yaw -= 1, move it again yaw is now yaw = 2, yaw = 3
		yaw -= event.relative.x  * SENS
		pitch -= event.relative.y * SENS
		
		
		pitch = clamp(pitch , deg_to_rad(-90), deg_to_rad(90))

func _input(event: InputEvent) -> void:
		
	if event.is_action_pressed("shoot"):
		attack_buffered = true
		
		if can_shoot:
			shoot()
	
	if event.is_action_released("shoot"):
		attack_buffered = false
	
	if event.is_action_pressed("pickup") and picking_up:
		picking_up = false
		pickable_obj.gravity_scale = 1.0
		
	if event.is_action_pressed("shop"):
		if get_tree().paused:
			get_tree().paused = false
		else:
			get_tree().paused = true
			enter_shop.emit()

@onready var glock_ray_cast: RayCast3D = $Camera3D/Sway/Idle/Glock/Laser/RayCast3D


func shoot():
		if !attack_buffered:
			return
		
		can_shoot = false
		var bullet: RigidBody3D = BULLET.instantiate()
		projectiles.add_child(bullet)
		bullet.global_position = bullet_spawn_pos.global_position
		bullet.global_basis = glock_ray_cast.global_basis
		#var target_global = glock_ray_cast.to_global(glock_ray_cast.target_position)
		#var bullet_dir = bullet.global_position.direction_to(target_global)
		var bullet_dir = glock_ray_cast.global_transform.basis.z
		bullet.apply_central_impulse(bullet_dir * 100.0)
		#bullet.apply_central_impulse(-glock_ray_cast.basis.z * 20.0)

		
		
		animation_tree.set("parameters/TimeScale/scale", fire_rate)
		animation_tree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		glock_sound.play(0.4)
		
		await animation_tree.animation_finished
		can_shoot = true
		
		shoot()


func _add_money(amount: int):
	print("money added")
	money += amount
	money_label.text = "$%d" % money
	var tween = create_tween()
	tween.tween_property(money_label, "modulate:a", 1.0, 0.5)
	tween.tween_property(money_label, "modulate:a", 0.0, 1.0).set_delay(3.0)

func _remove_money(amount: int):
	money -= amount
	money_label.text = "$%d" % money
