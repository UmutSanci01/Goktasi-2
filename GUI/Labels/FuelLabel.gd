extends Label


func _ready():
	if PlayerInventory.connect("update_inv", self, "_on_PlayerInv_update"): pass


func _on_PlayerInv_update():
	self.text = str(PlayerInventory.get_item_amount(ItemDB.FUEL))
