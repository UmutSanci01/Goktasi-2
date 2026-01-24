extends Control


signal slot_selected(slot, item_id)
signal press_empty()


onready var slot_scene = preload("res://GUI/Slot/Slot.tscn")
onready var slots = $PanelContainer/VBoxContainer/slots
onready var slot_indicator = $SelectedSlotIndicator
onready var lbl_title = $PanelContainer/VBoxContainer/Title


var inv : Inventory

var invisible_items : PoolIntArray = [] setget , get_invisible_items


func _ready():
	hide_slot_indicator()


func set_inv(inventory : Inventory):
	if not inventory.is_connected("update_inv", self, "_on_update_inv"):
		if inventory.connect("update_inv", self, "_on_update_inv"):
			pass
	
	self.inv = inventory
	
	update_slots()

func get_inv() -> Inventory:
	return inv


func set_invisible_item(item_id : int):
	invisible_items.append(item_id)
	
	update_slots()

func get_invisible_items():
	return


func hide_slot_indicator():
	slot_indicator.hide()


func update_slots():
	assert(inv, "inv is null")
	
	var size_inv_items = inv.items.size()
	var item_amount : int
	var item_texture : Texture
	
	var slot : Slot
	var slots_childs : Array = []
#	var counter_slot : int = 0
#	var size_slots_childs : int
	
	for child in slots.get_children():
		slots.remove_child(child)
		slots_childs.append(child)
		
#	size_slots_childs = slots_childs.size()
	
	for item_id in inv.items:
		if item_id in invisible_items:
			continue
		if ItemDB.check_item(item_id) == false:
			continue
		if ItemDB.get_item().visible == false:
			continue
		
		item_amount = inv.get_item_amount(item_id)
		item_texture = ItemDB.get_item().texture
		
		slot = slots_childs.pop_back()
		if not slot:
			slot = slot_scene.instance()
		
#		slots.add_child(slot)
		add_slot(slot)
		
		slot.set_item(item_id, item_amount, item_texture)
	
	# SLOT INDICATOR SIZE
	if slot:
		slot_indicator.rect_size = slot.rect_min_size
	
	for child in slots_childs:
		child.queue_free()


func add_slot(slot : Slot):
	slots.add_child(slot)

	if not slot.is_connected("button_down", self, "_on_Slot_down"):
		if slot.connect("button_down", self, "_on_Slot_down", [slot]):
			pass


func set_title(text : String):
	lbl_title.text = text


func _on_Slot_down(slot : Slot):
	if slot_indicator.visible == false:
		slot_indicator.show()
	
	slot_indicator.rect_global_position = slot.rect_global_position
	
	emit_signal("slot_selected", slot, slot.item_id)


func _on_update_inv():
	update_slots()


func _on_VBoxContainer_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			emit_signal("press_empty")
