extends Control


signal slot_selected(slot, item_id)
signal press_empty()


onready var slot_scene = preload("res://GUI/Slot/Slot.tscn")
onready var slots = $PanelContainer/VBoxContainer/slots
onready var slot_outline = $SelectedSlotIndicator
onready var lbl_title = $PanelContainer/VBoxContainer/Title
# onready var slot_fueled_indicator = preload("res://Images/fuel_indicator.png")


var inv : Inventory
var current_slot : Slot
var invisible_items : PoolIntArray = [] setget , get_invisible_items


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.SupplierBulletActive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierFuelActive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierBulletDeactive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierFuelDeactive)

	hide_slot_outline()


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


func hide_slot_outline():
	slot_outline.hide()

# Player and Store inventory is updating
func update_slots():
	assert(inv, "inv is null")
	
	# var size_inv_items = inv.items.size()
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
		
		var item_data : Item = ItemDB.get_item()
		if item_data.visible == false:
			continue
		
		item_amount = inv.get_item_amount(item_id)
		item_texture = item_data.texture
		
		slot = slots_childs.pop_back()
		if not slot:
			slot = slot_scene.instance()
		
#		slots.add_child(slot)
		add_slot(slot)
		
		slot.set_item(item_id, item_amount, item_texture)
		

	# SLOT OUTLINE SIZE
	if slot:
		slot_outline.rect_size = slot.rect_min_size
	
	for child in slots_childs:
		child.queue_free()

func add_slot(slot : Slot):
	slots.add_child(slot)

	if not slot.is_connected("button_down", self, "_on_Slot_down"):
		if slot.connect("button_down", self, "_on_Slot_down", [slot]):
			pass


func set_title(text : String):
	lbl_title.text = text


func _on_Notify(notification_type : int):
	if not current_slot: return
	if notification_type == Notification.NotificationTypes.SupplierBulletActive \
		or notification_type == Notification.NotificationTypes.SupplierFuelActive:
		
		current_slot.draw_indicator()

	if notification_type == Notification.NotificationTypes.SupplierBulletDeactive \
		or notification_type == Notification.NotificationTypes.SupplierFuelDeactive:
		
		current_slot.erase_indicator()

func _on_Slot_down(slot : Slot):
	if slot_outline.visible == false:
		slot_outline.show()
	
	slot_outline.rect_global_position = slot.rect_global_position
	current_slot = slot

	emit_signal("slot_selected", slot, slot.item_id)



func _on_update_inv():
	update_slots()

	# var amount : int = PlayerInventory.get_item_amount(item_id)
	# var is_depleted : bool = false
	# if amount == 0:
	# 	is_depleted = true

	# if current_slot and current_slot.get_item() == item_id:
	# 	if is_depleted:
	# 		is_depleted = false
	# 		current_slot.queue_free()
	# 		current_slot = null
	# 		return
	# 	current_slot.set_amount(amount)
	# else:
	# 	for slot in slots.get_children():
	# 		if slot.get_item() == item_id:
	# 			if is_depleted:
	# 				is_depleted = false
	# 				slot.queue_free()
	# 				return
	# 			slot.set_amount(amount)


func _on_VBoxContainer_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			emit_signal("press_empty")
