extends Node3D

@onready var upgrades: Control = $"../../../Shop/Upgrades"
@onready var hole_pos: Marker3D = $"../Enviroment/HolePos"
@onready var hole_direction: Marker3D = $"../Enviroment/HoleDirection"
@onready var game_tree: Node3D = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_tree.scooper_spawned.connect(_set_scooper_spots)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _set_scooper_spots(scooper):
	scooper.hole_pos = hole_pos
	scooper.hole_direction = hole_direction
