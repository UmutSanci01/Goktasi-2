extends VBoxContainer

signal settings_change(new_settings)
signal press_return

var is_settings_change : bool = false
var settings_data : Dictionary

func _ready():
	load_data()


func save_data():
	DataBase.save_data(settings_data, "settings")

func load_data():
	var new_data = DataBase.load_data("settings")
	if not new_data and not new_data is Dictionary:
		return
	
	settings_data = new_data
	emit_signal("settings_change", settings_data)

func hide():
	.hide()

func _on_ReturnTitle_button_down():
	save_data()
	emit_signal("press_return")

func _on_OreNum_change_value(data, value):
	settings_data[data] = value
	emit_signal("settings_change", settings_data)

func _on_Radius_change_value(data, value):
	settings_data[data] = value
	emit_signal("settings_change", settings_data)

func _on_SideNum_change_value(data, value):
	settings_data[data] = value
	emit_signal("settings_change", settings_data)


func _on_Reset_pressed():
	Notification.notify(Notification.NotificationTypes.Reset)
#	GameState.reset_game()
