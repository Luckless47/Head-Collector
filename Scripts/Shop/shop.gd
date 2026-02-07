extends Control
@onready var background: Control = $Background
@onready var money_counter: Control = $MoneyCounter
@onready var control: Control = $Control
@onready var upgrades: Control = $Upgrades
@onready var crt_startup: AudioStreamPlayer = $Upgrades/CRT_Startup
@onready var night_music: AudioStreamPlayer = $NightMusic
@onready var day_music: AudioStreamPlayer = $"../DayMusic"


signal exit_shop
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
 


func _on_continue_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("shoot"):
		exit_shop.emit()
		
		
func do_start_animation():
	day_music.stop()
	show()
	crt_startup.play(0.59)
	
	var tween = create_tween()
	tween.tween_property(background, "scale", Vector2(1.0, 1.0), 3.0).set_ease(Tween.EASE_OUT_IN).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	money_counter.show()
	control.show()
	upgrades.show()
	night_music.play()
	
@onready var vhs_effect: CanvasLayer = $"../VHSEffect"

func do_stop_animation():
	var tween = create_tween()
	tween.tween_property(background, "scale", Vector2(0.0, 0.0), 1.0).set_trans(Tween.TRANS_EXPO)
	

	money_counter.hide()
	control.hide()
	upgrades.hide()
	night_music.stop()
	crt_startup.stop()
	
	await tween.finished
	vhs_effect.hide()
	night_music.stop()
	hide()
	day_music.play()
