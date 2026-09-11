extends Control


onready var fuel_container = $PanelContainer/VBoxContainer/FuelContainer


var player_fuel
var base_fuel : int = 150
var remain_fuel : int = 0


func _ready():
	calc_remain_fuel()
	fuel_container.set_remain_fuel(remain_fuel)


func calc_remain_fuel():
	var discount_per_tier = 0.20
	var multiplier = max(0.3, 1.0 - (Upgrade.engine_tier * discount_per_tier))
	remain_fuel = int(base_fuel * multiplier)
	return remain_fuel

func show():
	.show()

	calc_remain_fuel()
	fuel_container.set_remain_fuel(remain_fuel)

func _on_Confirm_pressed():
#	if player_fuel < remain_fuel:
#		pass
#	else:
#	if PlayerInventory.use_item(Item.ID.FUEL, remain_fuel):
	if PlayerInventory.use_item_by_type(Item.Type.FUEL, remain_fuel):
		Random.randomize_rnd()
		Map.initialize(true)
		
		self.hide()
	else:
			InfoPanel.add_label("KEY_INSUFFICIENT_FUEL", "", Color(0.411765, 1, 0.921569))

func _on_Back_pressed():
	self.hide()


func _on_ItemAmountLabel_amount_update(new_amount):
	player_fuel = new_amount
