extends Control

signal bullet_type_changed(bullet_id)

export var slot_scene: PackedScene # Inspector'dan Slot.tscn'yi buraya sürükle

onready var anim: AnimationPlayer = $AnimationPlayer
onready var slot_container: Container = $Panel/SlotContainer

func _ready():
	visible = false 

func open_menu(): 
	visible = true 
	_refresh_slots()
	anim.play("Show")

func _refresh_slots():
	for child in slot_container.get_children():
		child.queue_free()
		
	var bullets: WrapSameType = PlayerInventory.get_item_by_type(Item.Type.BULLET)
	
	if bullets.total <= 0:
		InfoPanel.add_label("KEY_NO_AMMO")
		return
		
	for item_id in bullets.items:
		var amount: int = bullets.items[item_id]
		if amount <= 0:
			continue
			
		var data: Item = ItemDB.get_item(item_id)
		
		var new_slot = slot_scene.instance()
		slot_container.add_child(new_slot)
		new_slot.texture_normal = null

		new_slot.call_deferred("set_item", item_id, amount, data.texture)
		
		if not new_slot.is_connected("button_up", self, "_on_Slot_button_up"):
			new_slot.connect("button_up", self, "_on_Slot_button_up", [item_id])

func close_menu():
	GameState.is_bullet_menu_opened = false
	anim.play_backwards("Show")

func _on_Slot_button_up(item_id: int):
	if item_id > -1:
		GameState.selected_bullet_id = item_id
		emit_signal("bullet_type_changed", item_id)
		close_menu()