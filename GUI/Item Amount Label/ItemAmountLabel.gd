extends Label


signal amount_update(new_amount)


export (Item.ID) var item


func _ready():
	if PlayerInventory.connect("update_inv", self, "_on_PlayerInv_update"): pass


func _on_PlayerInv_update():
	var item_ : Item = ItemDB.get_item(item)
	var item_amount : int
	
	if item_.type == Item.Type.FUEL:
		item_amount = PlayerInventory.get_item_amount_by_type(Item.Type.FUEL)
	else:
		item_amount = PlayerInventory.get_item_amount(item)
	
	self.text = str(item_amount)
	emit_signal("amount_update", item_amount)
