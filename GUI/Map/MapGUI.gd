extends Control


onready var map_slot = preload("res://GUI/Map/Map Slot/MapSlot.tscn")


var rect = TextureRect.new()


func _ready():
	randomize()
	
	var grid_size = 5
	var map_area : Vector2 = Vector2.ONE * (grid_size * 16)
	var map_area_mid : Vector2 = map_area / 2
	var slot_num = grid_size * grid_size
	var screen_mid : Vector2 = get_viewport().size / 2
	
	var map_area_topleft : Vector2 = screen_mid - map_area_mid
	
	rect.texture = load("res://icon.png")
	add_child(rect)
	
	rect.rect_position = screen_mid
	
	var slot_pos_x = range(grid_size)
	var slot_pos_y = range(grid_size)
	slot_pos_x.shuffle()
	slot_pos_y.shuffle()
	
#	var slot_position : Vector2
#	var tilemap = TileMap.new()
#	for i in grid_size:
#		slot_position.x = slot_pos_x[i]
#		slot_position.y = slot_pos_y[i]
#
#		var slot = map_slot.instance()
#		slot.rect_position = tilemap.map_to_world(slot_position) + map_area_topleft
#
#		add_child(slot)


func _input(event):
	if Input.is_action_just_pressed("ui_down"):
		var mid = OS.get_window_size() / 2
		
		rect.rect_global_position = mid
