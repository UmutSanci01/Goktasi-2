extends Node


signal entered
signal exited


var is_reachable : bool = false setget set_reachable, get_reachable


var inv : Inventory = Inventory.new()
var id_coin : int = Item.ID.COIN
#var id_info_value : int = ItemDB.VALUE

var limited_items : Dictionary = {
	Item.ID.SUPPLIER_BULLET : 1,
	Item.ID.SUPPLIER_FUEL : 1,
	Item.ID.DETECTOR_ORE : 1
#	ItemDB.EnumItem.OreDetector : 1,
#	ItemDB.EnumItem.BulletSupplier : 1,
#	ItemDB.EnumItem.FuelSupplier : 1
}


func _ready():
	for item_id in range(Item.ID.size()):
		inv.add_item(item_id)


func buy(item_id : int, amount : int, to_inv : Inventory) -> int:
	if inv.has_item(item_id) == false:
		return 0
	
	if limited_items.has(item_id):
		if limited_items[item_id] < to_inv.get_item_amount(item_id) + amount:
			InfoPanel.add_label("Sahip Olabilirsin", str(limited_items[item_id]))
			return 0
	
	
	var item_value : int = 0
	if ItemDB.check_item(item_id):
		item_value = ItemDB.get_item().value
#	var item_value = ItemDB.get_item(item_id, id_info_value)
	if item_value <= 0:
		return 0
	
	if to_inv.check_item(id_coin, item_value * amount):
		to_inv.del_item(id_coin, item_value * amount)
		to_inv.add_item(item_id, amount)
	else:
		InfoPanel.add_label("Para Bitti", "", Color.gold)
	
	return to_inv.get_item_amount(item_id)


func sell(item_id : int, amount : int, from_inv : Inventory) -> int:
	var item_value : int = 0
	if from_inv.check_item(item_id, amount):
		if ItemDB.check_item(item_id):
			item_value = ItemDB.get_item().value
			
#		var item_value = ItemDB.get_item(item_id, id_info_value)
		if item_value <= 0:
			return 0
		
		from_inv.del_item(item_id, amount)
		from_inv.add_item(id_coin, item_value * amount)
		
		return from_inv.get_item_amount(item_id)
	
	InfoPanel.add_label("Yeteri Kadar Eşya Yok", "", Color.sandybrown)
	return 0


func get_inv():
	return inv


func set_reachable(val):
	is_reachable = val
	
	if is_reachable:
		emit_signal("entered")
	else:
		emit_signal("exited")

func get_reachable() -> bool:
	return is_reachable
