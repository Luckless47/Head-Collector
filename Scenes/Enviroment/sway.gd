extends Node3D


@export var swayLeft: Vector3
@export var swayRight: Vector3
@export var swayUp: Vector3
@export var swayDown: Vector3
@export var swayNormal: Vector3
@onready var ray_cast: RayCast3D = $Idle/Glock/Laser/RayCast3D

var mouseMovementY
var mouseMovementX
@export var swayThreshold := 5.0
@export var swayLerp := 1.0

var mouse_vel := Vector2.ZERO
@export var sway_strength := 0.002
@export var max_sway := 0.05
@export var sway_return := 10.0

var sway_offset := Vector3.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_vel = event.relative
		mouseMovementY = -event.relative.x
		mouseMovementX = event.relative.y

func _physics_process(delta: float) -> void:
	var target = Vector3(-mouse_vel.y * sway_strength,
						-mouse_vel.x * sway_strength,
						0.0)
						
	target.x = clamp(target.x, -max_sway, max_sway)
	target.y = clamp(target.y, -max_sway, max_sway)
	
	sway_offset = sway_offset.lerp(target, delta * sway_return)
	
	rotation = sway_offset
	#if mouseMovementY != null:
		#if mouseMovementY > swayThreshold:
			#rotation = rotation.lerp(swayLeft, swayLerp * delta)
		#elif mouseMovementY < -swayThreshold:
			#rotation = rotation.lerp(swayRight, swayLerp * delta)
		#
		#if mouseMovementX > swayThreshold:
			#rotation = rotation.lerp(swayUp, swayLerp * delta)
		#elif mouseMovementX < -swayThreshold:
			#rotation = rotation.lerp(swayDown, swayLerp * delta)
		#
		#else:
			#rotation = rotation.lerp(swayNormal, swayLerp * delta)
