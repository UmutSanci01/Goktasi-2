extends Node2D


var GUI : GraphicUI
var GAME : Game


func _ready():
	GUI = $GUI
	GAME = $Game
	
	# Map.initialize()
	
	GameState.gui = GUI
	GameState.ship = GAME.get_ship()
	GameState.meteor = GAME.get_meteor()
	
	InfoPanel.add_label("Oyun Başladı", "", Color.green)
	
	GameState.is_activate_detector = false

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_F11:
					OS.window_fullscreen = not OS.window_fullscreen
				_:
					pass

func _on_Map_curr_slot_changed(_slot_index : int, _slot_data : Map.Data):
	pass
#	GAME.set_meteor_settings(slot_data)


func _on_player_update_coin(_new_coin : int):
	pass


func _on_GUI_quit():
	get_tree().call_group("save_data", "save_data")
