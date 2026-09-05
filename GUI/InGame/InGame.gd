extends Control

signal press_return

onready var button_openinv = $OpenInv
onready var button_meteorinfo = $MeteorInfo
onready var ore_detector = $OreDetector
onready var bullet_container_texture = $AmountLabels/BulletContainer/BulletTexture
onready var bullet_container_amount = $AmountLabels/BulletContainer/BulletAmount
onready var fuel_container = $AmountLabels/FuelContainer
onready var ammo_choice_menu = $AmmoChoiceMenu

var touch_start : Vector2

func _ready():
	GameState.screen_safe_area = OS.get_window_safe_area()
	Notification.register_observer(self, Notification.NotificationTypes.SetShip)
	Notification.register_observer(self, Notification.NotificationTypes.SetMeteor)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorActive)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorDeactive)
	Notification.register_observer(self, Notification.NotificationTypes.BulletTypeChanged)
	
	ammo_choice_menu.close_menu()
	update_container()

func show():
	.show()

	TutorialOverlay.tutor_show(TutorialOverlay.Tutors.INGAME)

func update_container():
	# Bullet Container
	var bullet_id = GameState.selected_bullet_id
	bullet_container_texture.texture = ItemDB.get_item(bullet_id).texture
	bullet_container_amount.item = bullet_id
	bullet_container_amount.update()

func _unhandled_input(event):
	# Open the bullet choice menu if touchscreendrag direction is up.
	if event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			touch_start = event.position
		else:
			if not GameState.is_bullet_menu_opened \
					and touch_start.distance_squared_to(event.position) >= 200 * 200:
				
				var delta = event.position - touch_start
				if abs(delta.x) <= abs(delta.y):
					if delta.y <= 0:
						GameState.touch_position.x = touch_start.x
						GameState.touch_position.y = (event.position.y + touch_start.y) / 2.5
						GameState.is_bullet_menu_opened = true

						ammo_choice_menu.open_menu()
						# ammo_choice_menu.rect_position = event.position
						ammo_choice_menu.rect_position = GameState.touch_position
			else:
				if GameState.is_bullet_menu_opened:
					GameState.is_bullet_menu_opened = false
					ammo_choice_menu.close_menu()

					get_tree().set_input_as_handled()


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
	elif notification_type == Notification.NotificationTypes.BulletTypeChanged:
		var bullet_id = GameState.selected_bullet_id
		bullet_container_texture.texture = ItemDB.get_item(bullet_id).texture
		bullet_container_amount.item = bullet_id
		bullet_container_amount.update()



func _on_Return_button_down():
#	parent.set_menu(parent.title)
	emit_signal("press_return")


func _on_OpenInv_pressed():
	var parent : GraphicUI = get_parent()
	parent.set_menu(parent.store)

# func _draw():
	# if GameState.show_safe_area:
	# 	draw_rect(GameState.screen_safe_area, Color.red, false, 10)

func _on_MeteorInfo_pressed():
	var ore_num = GameState.get_ore_num()
	if ore_num:
		InfoPanel.add_label(GameState.get_ore_num(), "KEY_ORE_REMAINING", Color.aqua)
	else:
		InfoPanel.add_label("KEY_NO_ORE_LEFT", ore_num, Color.crimson)
