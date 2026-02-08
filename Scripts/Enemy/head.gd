extends RigidBody3D


var can_pickup := false


signal add_money

signal simulate_impact(projectile_pos)

func _ready() -> void:
	add_to_group("body_part")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if global_position.y < -7.0:
		queue_free()
		add_money.emit()
