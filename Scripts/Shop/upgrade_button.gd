extends TextureButton

class_name UpgradeButton

var upgrade_name := ""
var upgrade_price := 0
var upgrade_info := ""

@onready var button_sound: AudioStreamPlayer = $"../ButtonSound"
@onready var button_select_sound: AudioStreamPlayer = $"../ButtonSelectSound"


signal deploy_visuals(upgrade_button)
signal check_purchase(upgrade_price)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_button_press)


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_mouse_entered():
	deploy_visuals.emit(self)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.2)
	
	button_select_sound.pitch_scale = 1.0
	button_select_sound.play()

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)
	
	button_select_sound.pitch_scale = 0.5
	button_select_sound.play()
	
func _on_button_press(event: InputEvent):
	if event is InputEventMouseButton and event.is_action_pressed("shoot"):
		check_purchase.emit(self)
		button_sound.play()
		
		
