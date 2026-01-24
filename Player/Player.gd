extends Node

#class_name Player
#signal update_coin(new_coin)

#var coin : int = 3000 setget set_coin, get_coin

func _ready():
#	GameState.add_reset_group(self)
	
	if not load_data():
		PlayerInventory.add_item(Item.ID.COIN, 3000)
	
	if PlayerInventory.check_item(Item.ID.DETECTOR_ORE):
		GameState.has_player_detector = true


#func set_coin(new_value : int):
#	coin = new_value
	
#	emit_signal("update_coin", coin)


#func get_coin() -> int:
#	return coin

func save_data():
	var data = {"inv" : PlayerInventory.items}
	DataBase.save_data(data, "player")
	
func load_data():
	var my_data : Dictionary = DataBase.load_data("player")
	if my_data.empty():
		return 0
	
	if my_data.has("inv"):
		PlayerInventory.set_items(my_data["inv"])
		
		return 1


func _on_GUI_quit():
	save_data()

