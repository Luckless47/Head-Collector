extends Node3D
@onready var area_trip: Area3D = $Ground/Hole/AreaTrip


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_trip.body_entered.connect(_body_entered_trap)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _body_entered_trap(body):
	if body is Enemy:
		body.hole_trip.emit()
