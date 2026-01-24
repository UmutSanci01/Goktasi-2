extends Control


onready var fuel_container = $PanelContainer/VBoxContainer/FuelContainer


var player_fuel
var remain_fuel : int = 100


func _ready():
	fuel_container.set_remain_fuel(remain_fuel)


func _on_Confirm_pressed():
#	if player_fuel < remain_fuel:
#		pass
#	else:
	if PlayerInventory.use_item(Item.ID.FUEL, remain_fuel):
		Random.randomize_rnd()
		Map.initialize(true)
		
		self.hide()
	else:
		InfoPanel.add_label("Yeterli Yakıt Yok", "", Color(0.411765, 1, 0.921569))


func _on_Back_pressed():
	self.hide()


func _on_ItemAmountLabel_amount_update(new_amount):
	player_fuel = new_amount
