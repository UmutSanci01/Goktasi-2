extends Node2D

signal engine_upgrated(tier)

var engine_tier: int = 0 setget set_engine_tier

func _ready():
    add_to_group("save_data")
    load_data()

    Notification.register_observer(self, Notification.NotificationTypes.Reset)

func set_engine_tier(value: int):
    engine_tier = value

    match engine_tier:
        0:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)            
        1:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)
        2:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T1)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, true)
        3:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T1)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)
        _:
            pass
    
    Store.emit_signal("update_store")
    emit_signal("engine_upgrated", engine_tier)


func buy_engine_upgrade(item_id: int):
    match item_id:
        Item.ID.UPGRADE_ENGINE_T1:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(item_id, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)

            self.engine_tier = 1
        Item.ID.UPGRADE_ENGINE_T2:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T1)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(item_id, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, true)

            self.engine_tier = 2
        Item.ID.UPGRADE_ENGINE_T3:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T1)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            ItemDB.set_item_cansale(item_id, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)

            self.engine_tier = 3
        _:
            pass

func sell_engine_upgrade(item_id: int):
    match item_id:
        Item.ID.UPGRADE_ENGINE_T1:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T2)
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            ItemDB.set_item_cansale(item_id, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)
            self.engine_tier = 0
        Item.ID.UPGRADE_ENGINE_T2:
            PlayerInventory.del_item(Item.ID.UPGRADE_ENGINE_T3)
            PlayerInventory.add_item(Item.ID.UPGRADE_ENGINE_T1)
            ItemDB.set_item_cansale(item_id, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, true)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, false)
            self.engine_tier = 1
        Item.ID.UPGRADE_ENGINE_T3:
            PlayerInventory.add_item(Item.ID.UPGRADE_ENGINE_T2)
            ItemDB.set_item_cansale(item_id, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T1, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T2, false)
            ItemDB.set_item_cansale(Item.ID.UPGRADE_ENGINE_T3, true)
            self.engine_tier = 2
        _:
            pass

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