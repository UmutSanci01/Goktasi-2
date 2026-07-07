extends Control

signal press_return

onready var button_openinv = $OpenInv
onready var button_meteorinfo = $MeteorInfo
onready var ore_detector = $OreDetector
onready var fuel_container = $AmountLabels/FuelContainer

var touch_start : Vector2


func _ready():
	GameState.screen_safe_area = OS.get_window_safe_area()
	Notification.register_observer(self, Notification.NotificationTypes.SetShip)
	Notification.register_observer(self, Notification.NotificationTypes.SetMeteor)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorActive)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorDeactive)
	

	# Check Detector
#	if GameState.is_activate_detector:
#		ore_detector.show()
#	else:
#		ore_detector.hide()
	
#	GameState.register(self, GameState.NotificationType.SHIP_GLOBAL_POS)


#func _on_GameState_notify():
#	var mid = get_viewport_rect().get_center() - $OpenInv.rect_size / 2
#	$OpenInv.rect_global_position = GameState.ship_global_pos + mid

func _unhandled_input(event):
	# Open the bullet choice menu if touchscreendrag direction is up.
	if event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			touch_start = event.position
		else:
			if touch_start.distance_squared_to(event.position) >= 200 * 200:
				var delta = event.position - touch_start
				if abs(delta.x) <= abs(delta.y):
					if delta.y <= 0:
						InfoPanel.add_label("Menu acildi")
						GameState.is_bullet_menu_opened = true


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.SetShip:
		var mid = get_viewport_rect().get_center() - button_openinv.rect_size / 2
		button_openinv.rect_global_position = GameState.ship.global_position + mid
	
	# Meteorun uzerindeki gorunmez butonun boyutunu ayarliyor.
	elif notification_type == Notification.NotificationTypes.SetMeteor:
		var meteor = GameState.meteor
		var data = meteor.data
		
		button_meteorinfo.rect_size = Vector2.ONE * data.radius * 2
		
		var mid = get_viewport_rect().get_center() - button_meteorinfo.rect_size / 2
		button_meteorinfo.rect_global_position = GameState.meteor.global_position + mid
	
	# Yakit gostergesi de isin icine girdiginden buraya yazmisin.
	elif notification_type == Notification.NotificationTypes.OreDetectorActive:
		fuel_container.show()
		ore_detector.show()
	elif notification_type == Notification.NotificationTypes.OreDetectorDeactive:
		ore_detector.hide()
		fuel_container.hide()



func _on_Return_button_down():
	var parent : GraphicUI = get_parent()
#	parent.set_menu(parent.title)
	emit_signal("press_return")


func _on_OpenInv_pressed():
	var parent : GraphicUI = get_parent()
	parent.set_menu(parent.store)

func _draw():
	if GameState.show_safe_area:
		draw_rect(GameState.screen_safe_area, Color.red, false, 10)

func _on_MeteorInfo_pressed():
	var ore_num = GameState.get_ore_num()
	if ore_num:
		InfoPanel.add_label(GameState.get_ore_num(), "Maden Kaldı", Color.aqua)
	else:
		InfoPanel.add_label("Maden Kalmadı", ore_num, Color.crimson)
