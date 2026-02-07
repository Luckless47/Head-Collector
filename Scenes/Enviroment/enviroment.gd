extends Node3D
@onready var area_trip: Area3D = $Ground/Hole/AreaTrip
@onready var hole_pos: Marker3D = $HolePos
@onready var hole_direction: Marker3D = $HoleDirection
@onready var upgrades: Control = $"../../../Shop/Upgrades"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_trip.body_entered.connect(_body_entered_trap)

	


func _body_entered_trap(body):
	if body is Enemy:
		body.hole_trip.emit()
