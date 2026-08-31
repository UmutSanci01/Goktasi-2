extends Control

signal bullet_type_changed(bullet_id)

onready var anim : AnimationPlayer = $AnimationPlayer
onready var slots = $VBoxContainer.get_children()

func _ready():
    visible = false 

func open_menu(): 
    visible = true 
    
    var bullets : WrapSameType = PlayerInventory.get_item_by_type(Item.Type.BULLET)
    var slot_count = 0
    
    for item_id in bullets.items:
        var amount : int = bullets.items[item_id]
        var data : Item = ItemDB.get_item(item_id)
        var slot = slots[slot_count]
        
        slot.call_deferred("set_item", item_id, amount, data.texture)
        slot_count += 1

    while slot_count < 3:
        var slot = slots[slot_count]
        slot.call_deferred("clear_item")
        slot_count += 1
    
    anim.play("Show")

func close_menu():
    GameState.is_bullet_menu_opened = false
    anim.play_backwards("Show")

func _on_Slot_button_up(slot_index : int):
    var item_id = slots[slot_index].get_item()
    if item_id > -1:
        GameState.selected_bullet_id = item_id
        
        close_menu() 