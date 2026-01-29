class_name Supplier
extends Node2D


export (Item.ID) var product_item
export (Item.ID) var product_source
export (int) var product_num = 5
export (int) var product_cost = 1
export (int) var product_time = 5
export (int) var product_fuel = 1 # Fuel cost will added


onready var timer = $Timer


var is_active : bool = false


func _ready():
	timer.wait_time = product_time


func enable():
#	if PlayerInventory.get_item_amount(product_source) < product_cost:
	if not timer.time_left and not PlayerInventory.use_item(product_source):
		InfoPanel.add_label("Yeteri kadar malzeme yok.")
		return false
	
	InfoPanel.add_label("Üretici aktif", ItemDB.get_item(product_item).name, Color.green)
	if timer.time_left:
		timer.paused = false
	else:
		timer.start()
	
	is_active = true
	return true


func disable():
	InfoPanel.add_label("Üretici Pasif", ItemDB.get_item(product_item).name, Color.red)
	
	is_active = false
	if timer.time_left:
		timer.paused = true
	else:
		timer.stop()


func _on_Timer_timeout():
	PlayerInventory.add_item(product_item, product_num)
	
	if not PlayerInventory.use_item(product_source, product_cost):
		InfoPanel.add_label("Hammadde Tükendi", "", Color.tomato)
		timer.stop()
		disable()
