extends Control

class_name MapGrid

signal drag()
signal curr_slot_changed(new_slot, new_index)
signal slot_selected(slot, slot_index, dist)

#export var slot_num : int = 3

#onready var container_map_center = $MapCenterContainer
onready var indicator_current_slot = $CurrSlotIndicator
onready var indicator_target_slot = $TargetSlotIndicator
onready var slots = $Slots
onready var map_slot = preload("res://GUI/Map/Map Slot/MapSlot.tscn")


# click variables
var touch_point : Vector2
var is_click : bool = false

# drag variables
var is_drag : bool = false
var click_safe_limit : int = 400

# slot variables
var slot_num : int = 0
var grid_size : int = 0
var current_slot_index : int
var old_slot_index : int = -1
var current_slot : TextureButton
var slot_pool : Array = []
var iter_slot_pool : int setget set_iter_slot_pool
var is_init_pool : bool = false

# tile variables
var tile_size : int = 64
var screen_mid : Vector2
#var board_mid : Vector2

# checks
#var is_init_grid_size : bool = false

func _ready():
	slot_num = Map.SLOT_NUM
	
	screen_mid = get_viewport_rect().size / 2
#	board_mid = (Vector2.ONE * slot_num * tile_size) / 2


func add_slot(slot_position : Vector2, slot_texture : Texture):
	if not is_init_pool:
		init_slot_pool()
		iter_slot_pool = 0
	
	var slot : TextureButton = slot_pool[iter_slot_pool]
	
#	slot.rect_position = (screen_mid - board_mid) + slot_position
	slot.rect_position = slot_position
	slot.texture_normal = slot_texture
	
	mark_slot(slot.get_index())
	
	self.iter_slot_pool += 1
	
	return slot


func get_store_slot_global_pos():
	pass


func clear_slots():
	is_init_pool = false
	slots.clear()


func set_current_slot(slot_index : int):
	mark_slot(current_slot_index)
	
	current_slot = get_slot(slot_index)
	if not current_slot:
		print("MapGrid set current slot get slot return null")
		return
	
	current_slot_index = slot_index
	
	indicator_target_slot.hide()
	indicator_current_slot.rect_global_position = current_slot.rect_global_position
	
	emit_signal("curr_slot_changed", current_slot, current_slot_index)


func set_iter_slot_pool(val : int):
	if slot_pool.size() > 0:
		iter_slot_pool = (iter_slot_pool + 1) % slot_pool.size()
	else:
		print("MapGrid slot pool size lower than 0")


func get_slot(slot_index : int):
	if slot_index >= 0 and slot_index < slot_pool.size():
		return slot_pool[slot_index]
	
#	if slot_index >= 0 and slot_index < slots.get_child_count():
#		return slots.get_child(slot_index)
	
#	return container_map_center.get_slot(slot_index)


func init_slot_pool():
	assert(slot_num > 0)
	
	slot_pool.clear()
	
	var slot : TextureButton
	
#	while slot_num < slot_pool.size():
#		slot = slot_pool.pop_back()
#		if slot.is_connected("pressed", self, "_on_MapSlot_pressed"):
#			slot.disconnect("pressed", self, "_on_MapSlot_pressed")
#
#		slots.remove_child(slot)
#		slot.queue_free()
	
	for i in range(slot_num - slot_pool.size()):
		slot = map_slot.instance()
		slots.add_child(slot)
		slot_pool.append(slot)
		
		slot.connect("pressed", self, "_on_MapSlot_pressed", [slot, i])
	
	self.is_init_pool = true


func center_current_position():
	self.rect_position = (screen_mid - current_slot.rect_position) - (Vector2.ONE * tile_size / 2)


func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touch_point = event.position
			is_click = true
		else:
			is_drag = false
			
#			var slot = get_slot(current_slot_index)
		
	if event is InputEventScreenDrag:
		if is_drag:
			self.rect_position += event.relative
		
		elif touch_point.distance_squared_to(event.position) >= click_safe_limit:
			is_drag = true
			is_click = false
			
			emit_signal("drag")


func _on_MapSlot_pressed(slot : TextureButton, slot_index : int):
	if is_click and current_slot:
		is_click = false
		
		if (slot_index == current_slot_index):
			indicator_target_slot.hide()
		else:
			indicator_target_slot.show()
		
		indicator_target_slot.rect_global_position = slot.rect_global_position
		
		# calculate distance slot and current slot
		var dist : float = current_slot.rect_position.distance_to(slot.rect_position)
		var dist_tile : int = int(dist / slot.rect_size.x)
		
		emit_signal("slot_selected", slot, slot_index, dist_tile)


func move(slot_index : int):
	set_current_slot(slot_index)
	
#	center_current_position()


func mark_slot(slot_index):
	var slot : TextureButton = get_slot(slot_index)
	var slot_data : Map.Data = Map.get_data(slot_index)
	if slot and slot_data:
		if slot_data.type == Map.MapLocation.STORE:
			return
		
		if slot_data.is_ores_collected:
			slot.modulate = Color.darkslateblue
		elif slot_data.is_visited:
			slot.modulate = Color.burlywood
		else:
			slot.modulate = Color.white


# index and index2d
# index2d.x = (index % 30)
# index2d.y = (index / 30)
# index = (30 * index2d.y + index2d.x)
func index_to_index2d(index : int):
	var index2d : Vector2
	index2d.x = index % grid_size
	index2d.y = int(index / grid_size)
	
	return index2d

func index2d_to_index(index2d : Vector2):
	var index : int = (grid_size * index2d.y + index2d.x)
	
	return index


#func init_slots(slot_datas : Dictionary):
#	print("MapGrid init slots")
#	if slot_num <= 0:
#		return
#
#	var screen_mid : Vector2 = get_viewport_rect().size / 2
#	var board_mid : Vector2 = (Vector2.ONE * grid_size * tile_size) / 2
#
#	var parent_map_indicators = get_parent().map_indicators
#	var texture : Texture
#
#	var indexes_x : Array = range(grid_size)
#	var indexes_y : Array = range(grid_size)
#	indexes_x.shuffle()
#	indexes_y.shuffle()
#
#	for i in range(grid_size):
#		var slot
#		var data : Map.Data = slot_datas.get(i)
#
#		if not data:
#			continue
#
#		if not is_init_pool:
#			slot = map_slot.instance()
#			slots.add_child(slot)
#
#			slot_pool.append(slot)
#
#			slot.connect("pressed", self, "_on_MapSlot_pressed", [slot, i])
#
#		slot = slot_pool[i]
#
#		if data.has_index2d:
#			slot.rect_position = (screen_mid - board_mid) + (data.index2d * tile_size)
#		else:
#			var slot_index2d : Vector2 = Vector2(indexes_x.pop_front(), indexes_y.pop_front())
#			data.index2d = slot_index2d
#			data.has_index2d = true
#
#			slot.rect_position = (screen_mid - board_mid) + (slot_index2d * tile_size)
#
#		if data.radius <= 96:
#			texture = parent_map_indicators[0]
#		elif data.radius <= 128:
#			texture = parent_map_indicators[1]
#		elif data.radius <= 160:
#			texture = parent_map_indicators[2]
#		elif data.radius <= 196:
#			texture = parent_map_indicators[3]
#		else:
#			texture = parent_map_indicators[4]
#
#		slot.texture_normal = texture
#
#	is_init_pool = true


#func _gui_input(event):
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			touch_point = event.position
#			is_click = true
#		else:
#			is_drag = false
#
#			var slot = get_slot(current_slot_index)
#
#	if event is InputEventScreenDrag:
#		if is_drag:
#			self.rect_position += event.relative
#		elif touch_point.distance_squared_to(event.position) >= click_safe_limit:
#			is_drag = true
#			is_click = false
#
#			emit_signal("drag")


#func _on_Slots_sort_children():
#	# baslangicta mevcut slotun gostergesinin dogru sekilde yerlestirilmesi icin gerekli
#	set_current_slot(current_slot_index)
#
#	$MapBG.rect_position = container_map_center.rect_position
#	$MapBG.rect_size = container_map_center.rect_size



#func initialize_slots(slot_datas : Dictionary):
#	if not is_init_pool:
#		for _i in range(grid_size):
#			var slot = map_slot.instance()
#			slots.add_child(slot)
#
#			slot_pool.append(slot)
#
#			slot.connect("pressed", self, "_on_MapSlot_pressed", [slot, slot.get_index()])
#		is_init_pool = true
#
#	var mid : Vector2 = get_viewport_rect().size / 2
#	var board : Vector2 = Vector2.ONE * grid_size * tile_size
#
#	var parent_map_indicators = get_parent().map_indicators
#	var texture : Texture
#
#	var indexes = slot_datas.keys()
#	for i in range(grid_size):
#		var slot = slot_pool[i]
#		var index = indexes[i]
#
#		slot.rect_position = (mid - board / 2) + Vector2(index.x * tile_size, index.y * tile_size)
#
#		var data = slot_datas.get(index)
#		if data:
#			if data.radius <= 96:
#				texture = parent_map_indicators[0]
#			elif data.radius <= 128:
#				texture = parent_map_indicators[1]
#			elif data.radius <= 160:
#				texture = parent_map_indicators[2]
#			elif data.radius <= 196:
#				texture = parent_map_indicators[3]
#			else:
#				texture = parent_map_indicators[4]
#
#		slot.texture_normal = texture


#func init_slots(slot_datas : Dictionary):
#	slots.clear()
#
#	var mid : Vector2 = get_viewport_rect().size / 2
#	var board : Vector2 = Vector2.ONE * grid_size * tile_size
#
#	var parent_map_indicators = get_parent().map_indicators
#	var texture : Texture
#
#	for index2d in slot_datas:
#		var slot = map_slot.instance()
#		slots.add_child(slot)
#
#		slot.rect_position = (mid - board / 2) + Vector2(index2d.x * tile_size, index2d.y * tile_size)
#
#		slot.connect("pressed", self, "_on_MapSlot_pressed", [slot, slot.get_index()])
#
#		var data = slot_datas.get(index2d)
#		if data:
#			if data.radius <= 96:
#				texture = parent_map_indicators[0]
#			elif data.radius <= 128:
#				texture = parent_map_indicators[1]
#			elif data.radius <= 160:
#				texture = parent_map_indicators[2]
#			elif data.radius <= 196:
#				texture = parent_map_indicators[3]
#			else:
#				texture = parent_map_indicators[4]
#
#		slot.texture_normal = texture
#
#
#	set_current_slot(Map.current_slot_index)
	
#	slot_num = int(pow(grid_size, 2))
#
#	container_map_center.clear_slots()
#
#	container_map_center.set_columns(grid_size)
#	var texture : Texture
#	var parent_map_indicators = get_parent().map_indicators
#	for i in range(slot_num):
#		var data = slot_datas.get(i)
#		if data:
#			if data.radius <= 96:
#				texture = parent_map_indicators[0]
#			elif data.radius <= 128:
#				texture = parent_map_indicators[1]
#			elif data.radius <= 160:
#				texture = parent_map_indicators[2]
#			elif data.radius <= 196:
#				texture = parent_map_indicators[3]
#			else:
#				texture = parent_map_indicators[4]
#
#			data.texture = texture
#			container_map_center.add_slot(data.texture)
#		else:
#			container_map_center.add_slot()
