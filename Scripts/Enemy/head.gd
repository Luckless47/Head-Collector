extends RigidBody3D


signal add_money
var can_pickup := false

var money_value := 2

signal simulate_impact(projectile_pos)

func _ready() -> void:
	add_to_group("body_part")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if global_position.y < -7.0:
		add_money.emit(money_value)
		queue_free()
