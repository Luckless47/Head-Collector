extends Control


signal exit_shop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_continue_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("shoot"):
		exit_shop.emit()
