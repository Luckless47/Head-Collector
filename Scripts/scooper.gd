extends CharacterBody3D

@onready var head_collector: Area3D = $HeadCollector

var find_head = true
var pathfind = false
var pick_up
var check_sinkage = false

var hole_pos: Marker3D = null
var hole_direction: Marker3D = null
@onready var item_pos: Marker3D = $ItemPos

var nearest_head: RigidBody3D = null
var nearby_heads: Array[RigidBody3D] = []
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Keep Upright
	#rotation.z = 0
	#rotation.x = 0
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if nearest_head == null:
		find_head = true
		
	if find_head:
		find_nearest_head()
	
	elif pathfind:
		path_to_head()
		
	elif pick_up:
		pick_up_head()
		move_to_hole()
		

		
	move_and_slide()
		

func check():
	await get_tree().create_timer(2.0).timeout
	if nearest_head:
		pick_up = true
		nearest_head.gravity_scale = 0.0

func find_nearest_head():
	if !nearby_heads.is_empty():
		for head in nearby_heads:
			if !head.can_pickup:
				return
			
			var current_head_distance = global_position.distance_to(head.global_position)
			
			if nearest_head == null:
				nearest_head = head
				find_head = false
				pathfind = true
				continue
			
			var current_nearest_distance = global_position.distance_to(nearest_head.global_position)
			if current_nearest_distance > current_head_distance:
				nearest_head = head
				find_head = false
				pathfind = true
	

func path_to_head():
	look_at(nearest_head.global_position, Vector3.UP, true)
	
	var direction = global_position.direction_to(nearest_head.global_position)
	var distance = global_position.distance_to(nearest_head.global_position)
	
	var desired_velocity = direction * 2.0
	#var force = (desired_velocity - linear_velocity) * 10.0
	#apply_central_force(force)
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	
	
	#print(distance)
	if distance < 1.0:
		pathfind = false
		nearest_head.gravity_scale = 0.0
		pick_up = true
		
		velocity = Vector3.ZERO
		

func pick_up_head():
 
	var target_pos = item_pos.global_position
	var to_target = target_pos - nearest_head.global_position
	
	
	var desired_velocity = to_target * 10.0
	var force = (desired_velocity - nearest_head.linear_velocity) * 5.0
	
	nearest_head.apply_central_force(force)
	 
func move_to_hole():
	look_at(hole_direction.global_position, Vector3.UP, true)
	rotation.x = 0
	
	var direction = global_position.direction_to(hole_pos.global_position)
	var distance = global_position.distance_to(hole_pos.global_position)
	
	var desired_velocity = direction * 2.0
	#var force = (desired_velocity - linear_velocity)
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z

	
	if distance < 1.0:
		pick_up = false
		nearest_head.gravity_scale = 1.0
		
		check()
		

	

func _on_head_collector_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group("body_part") and !nearby_heads.has(body):
		nearby_heads.append(body)


func _on_head_collector_body_exited(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group("body_part") and nearby_heads.has(body):
		nearby_heads.erase(body)
