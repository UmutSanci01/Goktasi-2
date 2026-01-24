extends Control

class_name InventoryPanel

signal press_slot(slot_index, item_id)

onready var slot_scene = preload("res://GUI/Slot/Slot.tscn")
onready var slots = $Slots

var slot_num_counter : int = 0

var inventory : Inventory setget set_inv, get_inv

func set_inv(inv : Inventory):
#	if inventory and inventory.is_connected("update_inv", self, "_on_update_inv"):
	if inventory:
		inventory.disconnect("update_inv", self, "_on_update_inv")
	
	inventory = inv
	if inventory.connect("update_inv", self, "_on_update_inv"):
		print("zaten baglanmis")

func get_inv() -> Inventory:
	return inventory

func show_items():
	if not inventory:
		print("InventoryPanel inventory is null")
		return
	
	var item_num : int = inventory.items.size()
	var slot_num : int = slots.get_child_count()	
	var slot_iter : int = 0
	var slot : Slot
	var is_clear_slot : bool = false
	
	if slot_num > item_num:
		is_clear_slot = true
	
	for item in inventory.items:
#		if not ItemDB.get_item(item, ItemDB.VISIBLE):
#			continue
		
		if slot_iter < slot_num:
			slot = slots.get_child(slot_iter)
			if slot.get_item() == item:
				slot.set_amount(inventory.items[item])
			else:
				slot.set_item(item, inventory.items[item], ItemDB.get_item(item, ItemDB.IMAGE))
			
			slot_iter += 1
		else:
			slot = add_slot()
			slot.set_item(item, inventory.items[item], ItemDB.get_item(item, ItemDB.IMAGE))
			
			slot_iter += 1
	
	if is_clear_slot:
		var slots_children = slots.get_children()
		for _i in range(slot_iter, slot_num):
			slots.remove_child(slots_children.pop_back())

func add_slot():
	var slot = slot_scene.instance()
	slots.add_child(slot)
	
	slot.connect("button_down", self, "_on_slot_pressed", [slot.get_index(), slot.item_id])
	return slot

func _on_update_inv():
	show_items()

func get_slot(slot_index : int):
	if slot_index >= 0 and slot_index < slots.get_child_count():
		return slots.get_child(slot_index)

func reset():
	hide_indicator()

func hide_indicator():
	$SelectedIndicator.hide()

func show():
	.show()

func hide():
	.hide()
	
	reset()

func _on_slot_pressed(slot_index : int, _item_id : int):
	if $SelectedIndicator.visible == false:
		$SelectedIndicator.show()
	
	var slot : Slot = slots.get_child(slot_index)
	
	$SelectedIndicator.rect_position = slot.rect_position
	
	emit_signal("press_slot", slot_index, slot.item_id)
