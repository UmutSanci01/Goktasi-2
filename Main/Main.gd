extends Node2D


var GUI : GraphicUI
var GAME : Game


func _ready():
	GUI = $GUI
	GAME = $Game
	
	
#	if Player.connect("update_coin", self, "_on_player_update_coin"): pass

	if GUI.connect("quit", Player, "_on_GUI_quit"):
		pass
	
	Map.initialize()
	
	GameState.gui = GUI
	GameState.ship = GAME.get_ship()
	GameState.meteor = GAME.get_meteor()
	
	InfoPanel.add_label("Oyun Başladı", "", Color.green)
	GameState.is_activate_detector = false


func _on_Map_curr_slot_changed(_slot_index : int, slot_data : Map.Data):
	pass
#	GAME.set_meteor_settings(slot_data)


func _on_player_update_coin(_new_coin : int):
	pass


func _on_GUI_quit():
	get_tree().call_group("save_data", "save_data")
