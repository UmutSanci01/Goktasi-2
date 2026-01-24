extends CenterContainer

onready var map_empty_slot : PackedScene = preload("Map Slot/MapSlotEmpty.tscn")
onready var map_slot : PackedScene = preload("Map Slot/MapSlot.tscn")
onready var slots : GridContainer = $Slots

func add_slot(slot_texture : Texture = null, index : int = -1):
	var slot
	var to_connect : bool = false
	if slot_texture:
		slot = map_slot.instance()
		
		slot.texture_normal = slot_texture
		
		to_connect = true
#		if slot.connect("pressed", get_parent(), "_on_MapSlot_pressed", [slot]): pass
	else:
		slot = map_empty_slot.instance()
	
	slots.add_child(slot)
	
	if to_connect:
		to_connect = false
		if slot.connect("pressed", get_parent(), "_on_MapSlot_pressed", [slot, slot.get_index()]): pass


func add_slot_index2d(slot_texture : Texture = null, index : Vector2 = Vector2.ZERO):
	pass


func get_slot(slot_index : int):
	if slot_index >= 0 and  slot_index < slots.get_child_count():
		return slots.get_child(slot_index)
	
	return null


func clear_slots():
	if slots.get_child_count() > 0:
		for slot in slots.get_children():
			slots.remove_child(slot)

func set_columns(columns_num : int):
	slots.columns = columns_num
