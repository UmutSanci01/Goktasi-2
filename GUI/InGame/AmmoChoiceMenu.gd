extends Control

onready var slots = $VBoxContainer.get_children()

func show():
	.show()

	var bullets : WrapSameType = PlayerInventory.get_item_by_type(Item.Type.BULLET)
	var slot_count = 0
	for item_id in bullets.items:
		var amount : int = bullets.items[item_id]
		var data : Item = ItemDB.get_item(item_id)
		slots[slot_count].set_item(item_id, amount, data.texture)
		slot_count += 1

	if slot_count < 3:
		slots[slot_count].clear_item()

func hide():
	.hide()
	GameState.is_bullet_menu_opened = false
	# call from Gui.gd->set_menu

func _on_Slot_button_up():
	pass # Replace with function body.

func _on_Slot2_button_up():
	pass # Replace with function body.

func _on_Slot3_button_up():
	pass # Replace with function body.
