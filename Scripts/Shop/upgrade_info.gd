extends Control

class_name UpgradeInfo
@onready var upgrade_price: Label = $UpgradePrice
@onready var upgrade_info_label: Label = $UpgradeInfoLabel
@onready var upgrade_name_label: Label = $UpgradeName

#var price_tag
#var upgrade_info
#var upgrade_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.



func set_upgrade_visuals(new_price_tag, new_upgrade_info, new_upgrade_name):
	upgrade_price.text = "$%d" % new_price_tag
	upgrade_info_label.text = new_upgrade_info 
	upgrade_name_label.text =  "%s\n----------------------" % new_upgrade_name

	
