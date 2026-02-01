extends Control


class_name MapGUI


signal press_return()
#signal moved(data)
signal moved(slot_index, slot_dist)


#export var grid_size : int = 3


onready var mapgrid : MapGrid = $MapGrid
onready var label_fuel_remain : Label = $FuelRemain

onready var infopanel : Control = $InfoPanel
onready var panel_change_galaxy : Control = $ChangeGalaxyPanel

onready var indicator_store : TextureRect = $MapGrid/StoreIndicator


# animations
var tween_go : Tween = Tween.new()

# player variables
var player_fuel : int = 0

# map variables
var slot_num : int = 0

var map_indicators = [
	load("res://Images/MapIndicators/0.png"),
	load("res://Images/MapIndicators/1.png"),
	load("res://Images/MapIndicators/2.png"),
	load("res://Images/MapIndicators/3.png"),
	load("res://Images/MapIndicators/4.png")
]

var texture_store : Texture = preload("res://Images/shop_icon.png")


# slot variables
var slot_size : int = 64
var current_slot_index : int
var current_slot : TextureButton
var target_slot_index : int
var target_slot_dist : int = 0

var slot_store : TextureButton

var mid : Vector2
var screen_size : Vector2


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.Reset)
#	GameState.add_reset_group(self)
	
	add_child(tween_go)
	tween_go.connect("tween_all_completed", self, "_on_TweenGo_completed")
	
	if connect("moved", Map, "_on_MapGUI_moved"): pass
	if Map.connect("curr_slot_changed", self, "_on_Map_current_slot_changed"): pass
	if Map.connect("init", self, "_on_Map_init"): pass
	
	mid = get_viewport_rect().get_center()
	screen_size = get_viewport_rect().size - indicator_store.rect_size


var indicator_pos : Vector2
func _process(delta):
	indicator_pos = slot_store.rect_global_position
	
	if indicator_pos.x > screen_size.x:
		indicator_pos.x = screen_size.x
	if indicator_pos.x < 0:
		indicator_pos.x = 0
	if indicator_pos.y > screen_size.y:
		indicator_pos.y = screen_size.y
	if indicator_pos.y < 0:
		indicator_pos.y = 0
	indicator_store.rect_global_position = indicator_pos


func _input(event):
	if event is InputEventKey:
		if not event.pressed:
			return
		
		match event.scancode:
			KEY_S:
				pass
#				line.points = PoolVector2Array()
				
#				slot_rnd = mapgrid.get_slot(randi() % Map.SLOT_NUM)
#				var mid = mapgrid.rect_global_position
#				var mid = get_viewport_rect().get_center()
#				var slot_pos = slot_rnd.rect_global_position
#				var direction = slot_pos.normalized() * 100
#				var direction = (mid + mapgrid.rect_position)
#				$MapGrid/CurrSlotIndicator.rect_global_position = slot_pos
#				$MapGrid/TextureRect.rect_global_position = slot_pos
#				line.add_point(mid)
#				line.add_point(slot_pos + (Vector2.ONE * 32))

# Harita olusturuluyor.
func init_gui():
	var indexes_x : Array = range(slot_num)
	var indexes_y : Array = range(slot_num)
	indexes_x.shuffle()
	indexes_y.shuffle()
	
	
	if not Map.is_init_datas:
		print("MapGUI init_gui false")
		return
	
	mapgrid.clear_slots()
	
	for slot_index in Map.datas:
		var data : Map.Data = Map.get_data(slot_index)
		
		# Position
		var slot_position : Vector2
		
		if not data.has_index2d:
			var slot_index2d = Vector2(indexes_x.pop_back(), indexes_y.pop_back())
			data.index2d = slot_index2d
			data.has_index2d = true
			
		slot_position = data.index2d * slot_size
		
		# Texture
		var slot_texture : Texture
		var texture_index : int = 0
		
		if data.radius <= 96:
			texture_index = 0
		elif data.radius <= 128:
			texture_index = 1
		elif data.radius <= 160:
			texture_index = 2
		elif data.radius <= 196:
			texture_index = 3
		else:
			texture_index = 4
		
		slot_texture = map_indicators[texture_index]
		
		var is_store = false
		if data.type == Map.MapLocation.STORE:
			slot_texture = texture_store
			is_store = true
		
		var slot = mapgrid.add_slot(slot_position, slot_texture)
		if is_store:
			slot_store = slot
			indicator_store.rect_global_position = slot_store.rect_global_position
	
	current_slot_index = Map.current_slot_index
	mapgrid.move(Map.current_slot_index)


func show():
	.show()
	
	mapgrid.set_process_input(true)
	
	if slot_store:
		set_process(true)

func hide():
	.hide()
	
	mapgrid.set_process_input(false)
	set_process(false)


func go_current_location(duration : float = 0.5):
	var mid = get_viewport_rect().size / 2
	var center = (mid - current_slot.rect_position) - (Vector2.ONE * 32)

	tween_go.interpolate_property(mapgrid, "rect_position", mapgrid.rect_position, center, duration)
	tween_go.start()


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.Reset:
		# Go Market
		# Market is last object in the list
		if not Map.current_slot_index == Map.SLOT_NUM - 1:
			Map.set_current_slot_index(Map.SLOT_NUM - 1)


func _on_Return_button_down():
	emit_signal("press_return")


func _on_MapGrid_slot_selected(slot : TextureButton, slot_index : int, dist : int):
	target_slot_index = slot_index
	target_slot_dist = dist
	
	
	var slot_data = Map.get_data(slot_index)
	if slot_data:
		infopanel.set_data(slot_data.ore_num, slot_data.radius, dist)
		
#		infopanel.show()
		infopanel.pop(slot.rect_global_position)
	else:
		infopanel.hide()


#var end_point : Vector2
#var indicator_pos : Vector2
func _on_MapGrid_drag():
#	if slot_store:
#		end_point = slot_store.rect_global_position
#		indicator_pos = end_point
#
#
#		if indicator_pos.x > screen_size.x:
#			indicator_pos.x = screen_size.x
#		if indicator_pos.x < 0:
#			indicator_pos.x = 0
#		if indicator_pos.y > screen_size.y:
#			indicator_pos.y = screen_size.y
#		if indicator_pos.y < 0:
#			indicator_pos.y = 0
#		indicator_store.rect_global_position = indicator_pos
#
	infopanel.hide()


func _on_Map_init():
	slot_num = Map.SLOT_NUM
	
	init_gui()
	
	go_current_location(0.5)

# MapGrid move animasyonu yapiliyor.
func _on_Map_current_slot_changed(slot_index : int, slot_data : Map.Data):
	if not Map.is_init_curr_slot:
		slot_num = Map.SLOT_NUM
		mapgrid.slot_num = Map.SLOT_NUM
		init_gui()
		
		return
	
	current_slot_index = slot_index
	target_slot_index = slot_index
	target_slot_dist = 0
	
	go_current_location()
	yield(tween_go, "tween_all_completed")
	
	current_slot = mapgrid.get_slot(slot_index)
	
	infopanel.hide()
	
	
	go_current_location(1)
	yield(tween_go, "tween_all_completed")
	
	mapgrid.move(slot_index)


func _on_Travel_pressed():
	emit_signal("moved", target_slot_index, target_slot_dist)


func _on_ChangeGalaxy_pressed():
	panel_change_galaxy.show()


func _on_GoShip_pressed():
	if not current_slot:
		return
	
#	mapgrid.center_current_position()
	go_current_location(0.5)
	
	infopanel.hide()


func _on_MapGrid_curr_slot_changed(new_slot, _new_index):
	current_slot = new_slot
	
	if current_slot == slot_store:
		InfoPanel.add_label("Markete Erişilebilir", "", Color.gold)


func _on_TweenGo_completed():
	pass


func _on_MapGrid_slot_double_clicked(slot, slot_index):
	if slot_index == current_slot_index and slot == slot_store:
		GameState.gui.menu = GameState.gui.store
