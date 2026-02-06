extends Control


# Called when the node enters the scene tree for the first time.

const UPGRADE_ARROW = preload("uid://ubjd82k75urk")
# Called every frame. 'delta' is the elapsed time since the previous frame.
var button_offset = Vector2(30.0, 0.0)

var arrow_x_offsets = [-7.0, 0.0, 7.0]

func spawn(button_pos):
	show()
	
	var arrows = []
	
	for i in range(3):
		var upgrade_arrow = UPGRADE_ARROW.instantiate()
		add_child(upgrade_arrow)
		
		upgrade_arrow.global_position = button_pos + button_offset + Vector2(arrow_x_offsets[i], 0.0)
		arrows.append(upgrade_arrow)
		
	var tween = create_tween()
	tween.set_parallel(true)
	
	for arrow in arrows:
		var time_scale = randf_range(1.0 , 1.5)
		tween.tween_property(arrow, "global_position:y", arrow.global_position.y-60.0, time_scale)
		tween.tween_property(arrow, "modulate:a", 0.0, time_scale)
	
	await tween.finished
	
	for arrow in arrows:
		arrow.queue_free()
	
	hide()
	
	
	
