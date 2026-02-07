extends Control


@onready var upgrades = self.get_children()
@onready var upgrade_info: UpgradeInfo = $UpgradeInfo
@onready var furnace: Node3D = $"../../SubViewportContainer/SubViewport/Enviroment/Furnace"
const SCOOPER = preload("uid://b8d2cnopd8pma")

## Not all upgrades implemented yet
var upgrade_dict: Array = [{"Name": "Faster Firerate I", "Info": "1.0x -> 2.0x speed", "Price": 20},
							{"Name": "Longer Days I", "Info": "60 -> 70 seconds", "Price": 60},
							{"Name": "More Cash I", "Info": "1x -> 2x value", "Price": 15},
							{"Name": "Faster Spawner I", "Info": "5 -> 4 cooldown in seconds", "Price": 20},
							{"Name": "Bigger Grave Radius I", "Info": "0.5 -> 1.0 radius", "Price": 10},
							{"Name": "Scooper", "Info": "Dude who picks up heads for you", "Price": 50},
							{"Name": "Furnace", "Info": "???", "Price": 30},]
var player: CharacterBody3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_upgrades()
	game_tree.player_spawned.connect(_on_spawn)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_spawn(new_player):
	player = new_player

@onready var money_label: Label = $"../MoneyCounter/MoneyLabel"

func set_upgrades():
	var dict_idx = 0
	for upgrade in upgrades:
		if upgrade is UpgradeButton:
			var current_upgrade: UpgradeButton = upgrade
			var current_upgrade_dict = upgrade_dict[dict_idx]
			
			current_upgrade.upgrade_name = current_upgrade_dict["Name"]
			current_upgrade.upgrade_info = current_upgrade_dict["Info"]
			current_upgrade.upgrade_price = current_upgrade_dict["Price"]
			
			current_upgrade.deploy_visuals.connect(_set_visuals)
			current_upgrade.check_purchase.connect(_check_purchase)
			

			
			dict_idx += 1
		

@onready var game_tree: Node3D = $"../.."
@onready var hole: CSGCylinder3D = $"../../SubViewportContainer/SubViewport/Enviroment/Ground/Hole"
@onready var button_sound: AudioStreamPlayer = $ButtonSound
@onready var error_code: Label = $ErrorCode
@onready var upgrade_arrows: Control = $UpgradeArrows

@onready var upgrade_sound: AudioStreamPlayer = $UpgradeSound

func _set_visuals(upgrade_button):
	upgrade_info.set_upgrade_visuals(
	upgrade_button.upgrade_price, 
	upgrade_button.upgrade_info,
	upgrade_button.upgrade_name)
	
	money_label.text = "$%d" % game_tree.player.money
	
var display_arrows := false
func _check_purchase(upgrade_button):
	print(player.money, upgrade_button.upgrade_price)
	if player.money >= upgrade_button.upgrade_price:
		display_arrows = true
		player.remove_money.emit(upgrade_button.upgrade_price)
		
		match upgrade_button.upgrade_name:
			"Faster Firerate I":
				player.fire_rate = 2.0
				upgrade_button.upgrade_price = 25
				upgrade_button.upgrade_info = "2.0 -> 4.0 speed"
				upgrade_button.upgrade_name = "Faster Firerate II"
			"Faster Firerate II":
				player.fire_rate = 4.0
				upgrade_button.upgrade_price = 30
				upgrade_button.upgrade_info = "4.0 -> 8.0 speed"
				upgrade_button.upgrade_name = "Faster Firerate III"
			"Faster Firerate III":
				player.fire_rate = 8.0
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				#upgrade_button.disabled = true
		
			"Longer Days I":
				game_tree.day_length = 70.0
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				#upgrade_button.disabled = true
				
			"More Cash I":
				game_tree.money_value *= 2
				upgrade_button.upgrade_price = 30
				upgrade_button.upgrade_info = "2x -> 4x value"
				upgrade_button.upgrade_name = "More Cash II"
				
			"More Cash II":
				game_tree.money_value *= 2
				#upgrade_button.disabled = true
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				
			"Faster Spawner I":
				game_tree.spawn_rate = 4
				upgrade_button.upgrade_price = 40
				upgrade_button.upgrade_info = "4 -> 3 cooldown in seconds"
				upgrade_button.upgrade_name = "Faster Spawner II"
				
			"Faster Spawner II":
				game_tree.spawn_rate = 3
				#upgrade_button.disabled = true
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				
			"Bigger Grave Radius I":
				hole.radius = 1.0
				#upgrade_button.disabled = true
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				
			"Furnace":
				furnace.process_mode = Node.PROCESS_MODE_INHERIT
				furnace.show()
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
			
			"Scooper":
				var scooper = SCOOPER.instantiate()
				game_tree.scooper_pool.add_child(scooper)
				scooper.global_position = game_tree.scooper_pool.global_position
				game_tree.scooper_spawned.emit(scooper)
				upgrade_button.upgrade_info = ""
				upgrade_button.upgrade_name = "Purchased"
				
			"Purchased":
				display_arrows = false
				if !displaying:
					display_error_code()
		
		upgrade_sound.play()
		_set_visuals(upgrade_button)
		
	else:
		display_arrows = false
		if !displaying:
			display_error_code()
	
	if display_arrows:
		upgrade_arrows.spawn(upgrade_button.global_position)

var displaying := false
	
func display_error_code():
	displaying = true
	error_code.show()
	await get_tree().create_timer(3.0).timeout
	displaying = false
	error_code.hide()
