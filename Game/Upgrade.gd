extends Node2D

signal engine_upgraded(tier)

var engine_tier: int = 0 setget set_engine_tier

const UPGRADE_DATA = {
	0: { "current": null, "next": Item.ID.UPGRADE_ENGINE_T1 },
	1: { "current": Item.ID.UPGRADE_ENGINE_T1, "next": Item.ID.UPGRADE_ENGINE_T2 },
	2: { "current": Item.ID.UPGRADE_ENGINE_T2, "next": Item.ID.UPGRADE_ENGINE_T3 },
	3: { "current": Item.ID.UPGRADE_ENGINE_T3, "next": null }
}

func _ready():
	add_to_group("save_data")
	load_data()
	Notification.register_observer(self, Notification.NotificationTypes.Reset)

func set_engine_tier(value: int):
	if not UPGRADE_DATA.has(value):
		return
		
	engine_tier = value
	_update_inventory_and_store()
	
	Store.emit_signal("update_store")
	emit_signal("engine_upgraded", engine_tier)

func _update_inventory_and_store():
	ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
	ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
	ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)
	
	var data = UPGRADE_DATA[engine_tier]
	
	for tier_item in [Item.ID.UPGRADE_ENGINE_T1, Item.ID.UPGRADE_ENGINE_T2, Item.ID.UPGRADE_ENGINE_T3]:
		if data["current"] != tier_item:
			PlayerInventory.del_item(tier_item)
	
	if data["current"] != null:
		ItemDB.set_item_cansale(data["current"], false)
		
	if data["next"] != null:
		ItemDB.set_item_cansale(data["next"], true)
	
	Store.refresh_store_inventory()

func buy_engine_upgrade(item_id: int):
	var data = UPGRADE_DATA[engine_tier]
	if data["next"] == item_id:
		self.engine_tier += 1

func sell_engine_upgrade(item_id: int):
	var data = UPGRADE_DATA[engine_tier]
	if data["current"] == item_id and engine_tier > 0:
		var prev_data = UPGRADE_DATA[engine_tier - 1]
		if prev_data["current"] != null:
			PlayerInventory.add_item(prev_data["current"])
			
		self.engine_tier -= 1

func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.Reset:
		self.engine_tier = 0

func save_data():
	var data: Dictionary = {"engine_tier": engine_tier}
	DataBase.save_data(data, "Upgrade")

func load_data():
	var data : Dictionary = DataBase.load_data("Upgrade")
	if not data.empty():
		self.engine_tier = data["engine_tier"]