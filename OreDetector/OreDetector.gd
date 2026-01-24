extends Control


onready var timer = $Timer
onready var timer_fuel = $TimerFuel
onready var line = $Lines/Line2D


var num_point : int = 15

var max_hight : int = 64
var seperation : int = 16
var percent : int = 0
var center : int = 0
var sensivity : float = 1


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.OreDetected)
	Notification.register_observer(self, Notification.NotificationTypes.SetShip)
	
	
	var points : PoolVector2Array
	for i in range(num_point):
		points.append(Vector2(i * seperation, center))
	
	line.points = points
	$Lines/MidLine.add_point(line.points[0])
	$Lines/MidLine.add_point(line.points[-1])
	
	timer_fuel.wait_time = GameState.detector_fuel_cost


#func _input(event):
#	if event is InputEventKey:
#		if event.pressed == false:
#			return
#
#		match event.scancode:
#			KEY_UP:
#				percent += 1
#			KEY_DOWN:
#				percent = max(0, (percent - 1))
#			KEY_RIGHT:
#				sensivity += 0.1
#			KEY_LEFT:
#				sensivity -= 0.1
		
#		InfoPanel.add_label("Percent", percent)
#		InfoPanel.add_label("Sensivity", sensivity)
#		ConsoleGUI.out("Percent " + str(percent))
#		ConsoleGUI.out("Sensivity " + str(sensivity))


func show():
	.show()
	
	if GameState.has_player_detector:
		InfoPanel.add_label("Maden Dedektörü Aktif", "", Color.green)
	
	timer.start()
	timer_fuel.start()

func hide():
	.hide()
	
	if GameState.has_player_detector:
		InfoPanel.add_label("Maden Dedektörü Pasif", "", Color.orangered)
	
	timer.stop()
	timer_fuel.stop()


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.OreDetected:
		percent = GameState.detected_ore
	elif notification_type == Notification.NotificationTypes.SetShip:
		var line_size = line.points[-1] - line.points[0]
		
		var mid = get_viewport_rect().get_center() - (line_size / 2)
		$Lines.global_position.x = (GameState.ship.global_position + mid).x


func _on_Timer_timeout():
	for i in range(num_point - 1):
		line.points[i].y = line.points[i + 1].y
	
	line.points[-1].y = center - min(center + 64, pow(percent, 2) * sensivity)


func _on_TimerFuel_timeout():
	if not PlayerInventory.use_item(Item.ID.FUEL):
		GameState.is_activate_detector = false
		
		InfoPanel.add_label("Yakıt Tükendi", "", Color.red)
