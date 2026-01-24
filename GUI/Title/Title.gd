extends Control


signal press_start
signal press_settings
signal press_quit
signal press_store
signal press_map


#func _gui_input(event):
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			emit_signal("press_start")


func _on_Start_pressed():
	emit_signal("press_start")

func _on_Settings_button_down():
	emit_signal("press_settings")

func _on_Store_button_down():
	emit_signal("press_store")

func _on_Map_button_down():
	emit_signal("press_map")

func _on_Quit_button_down():
	emit_signal("press_quit")
