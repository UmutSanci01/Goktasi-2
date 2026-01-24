extends Inventory


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.Reset)
#	GameState.add_reset_group(self)
	Console.add_command(self, "para")


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.Reset:
		items.clear()
		
		add_item(Item.ID.COIN, 3000)
		
		emit_signal("update_inv")


func para():
	add_item(Item.ID.COIN, 10000)

#func _on_Store_buy(item_id : int, _item_data : Dictionary):
#	add_item(item_id)
