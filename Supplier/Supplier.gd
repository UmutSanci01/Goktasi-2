class_name Supplier
extends Node2D


export (Item.ID) var product_item
export (int) var product_num = 5
export (int) var product_cost = 1
export (int) var product_time = 5


onready var timer = $Timer


var is_active : bool = false


func _ready():
	timer.wait_time = product_time


func enable():
	if PlayerInventory.get_item_amount(Item.ID.ORE) < product_cost:
		InfoPanel.add_label("Yeteri kadar maden yok.")
		return false
	
	InfoPanel.add_label("Üretici aktif", ItemDB.get_item(product_item).name, Color.green)
	timer.start()
	
	is_active = true
	return true


func disable():
	InfoPanel.add_label("Üretici Pasif", ItemDB.get_item(product_item).name, Color.red)
	
	is_active = false
	timer.stop()


func _on_Timer_timeout():
	if PlayerInventory.use_item(Item.ID.ORE, product_cost):
		PlayerInventory.add_item(product_item, product_num)
	else:
		InfoPanel.add_label("Maden Tükendi", "", Color.tomato)
		disable()
