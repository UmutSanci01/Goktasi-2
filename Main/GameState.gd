extends Node


var ship : SpaceShip setget set_ship
var meteor : Meteor setget set_meteor

var detected_ore : int = 0
var is_activate_detector : bool = false setget set_is_activate_detector
var has_player_detector : bool = false
var detector_fuel_cost : int = 5

var is_infopanel_out : bool = false
var is_infopanel_completely_out : bool = false


# command flags
var is_free_travel : bool = false


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.Reset)
	
	
	Console.add_command(self, "free_travel")


#var state : bool = false
#func _input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_P:
#			if state:
#				get_tree().change_scene("res://Main/Main.tscn")
#			else:
#				get_tree().change_scene("res://Cockpit/Cockpit.tscn")
#
#			state = not state


func set_ship(s : SpaceShip):
	ship = s
#	ship_global_pos = global_pos
	Notification.notify(Notification.NotificationTypes.SetShip)

func set_meteor(m : Meteor):
	meteor = m
	Notification.notify(Notification.NotificationTypes.SetMeteor)


func set_is_activate_detector(value : bool):
	if value:
		Notification.notify(Notification.NotificationTypes.OreDetectorActive)
	else:
		Notification.notify(Notification.NotificationTypes.OreDetectorDeactive)
	
	is_activate_detector = value


func get_ore_num():
	return meteor.data.ore_num


func free_travel():
	self.is_free_travel = not self.is_free_travel


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.Reset:
		# Oyun verisini sil
		var path = DataBase.data_store_path
		
		var dir = Directory.new()
		if dir.open(path) == OK:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			while file_name != "":
				if dir.current_is_dir():
					pass
				else:
					dir.remove(path + "/" + file_name)
				file_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")
		
		InfoPanel.add_label("Oyun Sıfırlandı", "", Color.red)
		
