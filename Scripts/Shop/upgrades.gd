extends Control


@onready var upgrades = self.get_children()
@onready var upgrade_info: UpgradeInfo = $UpgradeInfo

## Not all upgrades implemented yet
var upgrade_dict: Array = [{"Name": "Faster Firerate I", "Info": "1.0 -> 2.0", "Price": 20},
							{"Name": "Longer Days I", "Info": "60 -> 70", "Price": 80},
							{"Name": "More Cash I", "Info": "1x -> 2x", "Price": 100},
							{"Name": "Faster Spawner I", "Info": "5.0 -> 4.0", "Price": 40},
							{"Name": "Bigger Grave Radius I", "Info": "0.5 -> 1.0", "Price": 40},
							{"Name": "Bruiser", "Info": "Get a bruiser to help you knock'em up", "Price": 130},]
@onready var player: CharacterBody3D = $"../../SubViewportContainer/SubViewport/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_upgrades()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
		


func _set_visuals(upgrade_button):
	upgrade_info.set_upgrade_visuals(
	upgrade_button.upgrade_price, 
	upgrade_button.upgrade_info,
	upgrade_button.upgrade_name)

func _check_purchase(upgrade_button):
	print(player.money, upgrade_button.upgrade_price)
	if player.money >= upgrade_button.upgrade_price:
		print("purchase success")
		player.remove_money.emit(upgrade_button.upgrade_price)
		
		match upgrade_button.upgrade_name:
			"Faster Firerate I":
				player.fire_rate = 2.0
				upgrade_button.upgrade_price = 40
				upgrade_button.upgrade_info = "2.0 -> 4.0"
				upgrade_button.upgrade_name = "Faster Firerate II"
			"Faster Firerate II":
				player.fire_rate = 4.0
				upgrade_button.upgrade_price = 80
				upgrade_button.upgrade_info = "4.0 -> 8.0"
				upgrade_button.upgrade_name = "Faster Firerate III"
			"Faster Firerate III":
				player.fire_rate = 8.0
				upgrade_button.disabled = true
		
		_set_visuals(upgrade_button)
				
