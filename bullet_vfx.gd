extends Area3D


var damage = 0
@export var speed := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += -global_transform.basis.z * speed * delta


func _on_body_entered(body: Node3D) -> void:
	body.take_damage.emit(damage, global_position)
	queue_free()
