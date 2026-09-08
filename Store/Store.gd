extends Node


signal entered
signal exited
signal update_store


var is_reachable : bool = false setget set_reachable, get_reachable


var inv : Inventory = Inventory.new()
var id_coin : int = Item.ID.COIN

var limited_items : Dictionary = {
	Item.ID.SUPPLIER_BULLET : 1,
	Item.ID.SUPPLIER_FUEL : 1,
	Item.ID.DETECTOR_ORE : 1,
	Item.ID.UPGRADE_ENGINE_T1 : 1,
	Item.ID.UPGRADE_ENGINE_T2 : 1,
	Item.ID.UPGRADE_ENGINE_T3 : 1
}


func _ready():
	for item_id in range(Item.ID.size()):
		if ItemDB.get_item(item_id).can_sale:
			inv.add_item(item_id)


func buy(item_id : int, amount : int, to_inv : Inventory) -> int:
	if inv.has_item(item_id) == false:
		return 0
	
	if limited_items.has(item_id):
		if limited_items[item_id] < (to_inv.get_item_amount(item_id) + amount):
			InfoPanel.add_label("KEY_CAN_HAVE", str(limited_items[item_id]))
			return 0
	
	
	var item : Item = ItemDB.get_item(item_id)
	var item_value : int = 0

	if item:
		item_value = item.value

	if item_value <= 0:
		return 0

	if to_inv.check_item(id_coin, item_value * amount):
		to_inv.del_item(id_coin, item_value * amount)
		to_inv.add_item(item_id, amount)

		if item.type == Item.Type.UPGRADE:
			Upgrade.buy_engine_upgrade(item_id)
			emit_signal("update_store")

		return to_inv.get_item_amount(item_id)
	else: # disabled
		InfoPanel.add_label("KEY_NO_MONEY", "", Color.gold)
		return 0


func sell(item_id : int, amount : int, from_inv : Inventory) -> int:
	var item_value : int = 0
	var item : Item = null
	if from_inv.check_item(item_id, amount):
		item = ItemDB.get_item(item_id)
		if item:
			item_value = item.value

		if item_value <= 0:
			return 0
		
		if item.type == Item.Type.UPGRADE:
			Upgrade.sell_engine_upgrade(item_id)
			emit_signal("update_store")

		from_inv.del_item(item_id, amount)
		from_inv.add_item(id_coin, item_value * amount)
		
		return from_inv.get_item_amount(item_id)
	
	InfoPanel.add_label("KEY_INSUFFICIENT_ITEMS", "", Color.sandybrown)
	return 0


func get_inv():
	return inv


func set_reachable(val):
	if is_reachable == val:
		return
	
	is_reachable = val
	
	if is_reachable:
		emit_signal("entered")
	else:
		emit_signal("exited")

func get_reachable() -> bool:
	return is_reachable
