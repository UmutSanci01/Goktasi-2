extends Node


signal entered
signal exited
signal update_store


var is_reachable : bool = false setget set_reachable, get_reachable


var inv : Inventory = Inventory.new()
var id_coin : int = Item.ID.COIN
var nuke_count : int = 0

var limited_items : Dictionary = {
	Item.ID.SUPPLIER_BULLET : 1,
	Item.ID.SUPPLIER_FUEL : 1,
	Item.ID.DETECTOR_ORE : 1,
	Item.ID.UPGRADE_ENGINE_T1 : 1,
	Item.ID.UPGRADE_ENGINE_T2 : 1,
	Item.ID.UPGRADE_ENGINE_T3 : 1,
	Item.ID.BULLET_NUKE : 1
}

var sell_multiplier : float = 0.8

func _ready():
	add_to_group("save_data")

	calc_nuke_limit()
	load_data()

	Map.connect("init", self, "_on_Map_init")

	refresh_store_inventory()


func refresh_store_inventory():
	var available_items : Dictionary = {}

	for item_id in range(Item.ID.size()):
		var item : Item = ItemDB.get_item(item_id)
		if item and item.can_sale:
			available_items[item_id] = 1

	inv.set_items(available_items)
	emit_signal("update_store")


func buy(item_id : int, amount : int, to_inv : Inventory) -> int:
	if inv.has_item(item_id) == false:
		return 0
	
	if limited_items.has(item_id):
		var temp : int = 0
		if item_id == Item.ID.BULLET_NUKE:
			temp = nuke_count + amount
		else:
			temp = to_inv.get_item_amount(item_id) + amount
				
		if limited_items[item_id] < temp:
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
		if item.id == Item.ID.BULLET_NUKE:
			nuke_count += amount
			emit_signal("update_store")

		return to_inv.get_item_amount(item_id)
	else: # disabled
		InfoPanel.add_label("KEY_NO_MONEY", "", Color.gold)
		return 0


func sell(item_id : int, amount : int, from_inv : Inventory) -> int:
	var item_value : int = 0
	var item : Item = null
	var sellable_amount : int = from_inv.check_item(item_id, amount)
	# if from_inv.check_item(item_id, amount):
	if sellable_amount > 0:
		item = ItemDB.get_item(item_id)
		if item:
			item_value = item.value

		if item_value <= 0:
			return 0
		
		if item.type == Item.Type.UPGRADE:
			Upgrade.sell_engine_upgrade(item_id)
			emit_signal("update_store")
		if item.id == Item.ID.BULLET_NUKE:
			nuke_count -= sellable_amount
			if nuke_count < 0: nuke_count = 0
			emit_signal("update_store")

		from_inv.del_item(item_id, sellable_amount)
		from_inv.add_item(id_coin, int((item_value * sell_multiplier) * sellable_amount))

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

func calc_nuke_limit():
	var nuke_limit : int = int(clamp(Map.SLOT_NUM / 15.0, 1, 4))

	limited_items[Item.ID.BULLET_NUKE] = nuke_limit
	nuke_count = 0

	emit_signal("update_store")

func _on_Map_init():
	calc_nuke_limit()

func save_data():
	DataBase.save_data({"nuke_count" : nuke_count}, "Store")

func load_data():
	var data : Dictionary = DataBase.load_data("Store")
	if not data.empty():
		nuke_count = data["nuke_count"]

func test_sell():
	pass