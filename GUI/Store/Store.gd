extends Control

signal press_return

onready var inv_panel : InventoryPanel = $InventoryPanel
onready var label_coin : Label = $Infos/HBoxContainer/Coin
onready var label_owner : Label = $HSplitContainer/VBoxContainer/InvOwnerName
onready var label_value : Label = $HSplitContainer/VBoxContainer2/ContainerValue/ItemValue
onready var label_amount : Label = $HSplitContainer/VBoxContainer2/HBoxContainer/ItemAmount
onready var item_info : RichTextLabel = $Infos/ItemInfo
onready var multiple_buy : HBoxContainer = $Buttons/Action/MultipleBuySlider
onready var button_action : TextureButton = $Buttons/Action

var inv : Inventory = Inventory.new("Market")
var selected_item_id : int = -1
var selected_slot_index : int = -1

var item_amount : int = 0
var item_remain : int = 0

enum Mode {
	Buy,
	Sell
}

var current_mode = Mode.Buy
var inventoryes : Dictionary = {
	Mode.Buy : inv,
	Mode.Sell : PlayerInventory
}

func _ready():
	for item_id in ItemDB.items:
		if ItemDB.get_item(item_id, ItemDB.VISIBLE):
			inv.add_item(item_id)
#
#	Console.store_node = self
	
	reset()

func reset(is_soft : bool = false):
	if not is_soft:
		current_mode = Mode.Buy
		inv_panel.set_inv(inventoryes[current_mode])
		
		var items_data : Dictionary = DataBase.load_data("store_inv")
		if not items_data.empty():
			inv.set_items(items_data)
	
	selected_item_id = -1
	selected_slot_index = -1
	
	item_info.text = ""
	
#	label_value.text = ""
	label_coin.text = str(Player.coin)
	label_owner.text = inv_panel.inventory.owner_name
	
	var action_button_atlas : AtlasTexture = button_action.texture_normal
	action_button_atlas.region.position.x = current_mode * 64
	button_action.texture_normal = action_button_atlas
	
	multiple_buy.hide()
	
	inv_panel.reset()
	inv_panel.show_items()

func update():
	.update()
	label_coin.text = str(Player.coin)
	label_amount.text = str(PlayerInventory.get_item_amount(selected_item_id))
	
#	multiple_buy.hide()
	

func hide():
	.hide()
	reset()

func show():
	.show()
	
	reset()

func get_inv():
	return inv

func _on_Return_pressed():
	DataBase.save_data(inv.items, "store_inv")
	emit_signal("press_return")

func _on_ChangeInventory_pressed():
	if current_mode == Mode.Buy:
		current_mode = Mode.Sell
	elif current_mode == Mode.Sell:
		current_mode = Mode.Buy
	
	inv_panel.set_inv(inventoryes[current_mode])
	reset(true)
	
func _on_Action_pressed():
	var selected_slot = inv_panel.get_slot(selected_slot_index)
	if not selected_slot:
		return
	
	selected_item_id = selected_slot.item_id
	var item_value = ItemDB.get_item(selected_item_id, ItemDB.VALUE)
	
	if current_mode == Mode.Sell: # PlayerInventory \ Sell
		if PlayerInventory.use_item(selected_item_id, item_amount):
#			inv.add_item(selected_item_id, item_amount)
			Player.coin += item_value * item_amount
			item_remain = PlayerInventory.get_item_amount(selected_item_id)
		
	elif current_mode == Mode.Buy: # Market Inventory \ Buy
		if Player.coin < item_value * item_amount:
			return
		
		PlayerInventory.add_item(selected_item_id, item_amount)
		Player.coin -= item_value * item_amount
		item_remain = inv.get_item_amount(selected_item_id)
	
	update()

func _on_InventoryPanel_press_slot(slot_index : int, item_id : int):
	selected_slot_index = slot_index
	selected_item_id = item_id
	
	var item_data = ItemDB.get_item(item_id)
	var item_num : int = 0
	if item_data:
		item_info.text = str(item_data[ItemDB.INFO])
		label_value.text = str(item_data[ItemDB.VALUE])
		label_amount.text = str(PlayerInventory.get_item_amount(item_id))
		
		if current_mode == Mode.Buy:
			item_num = int(Player.coin / ItemDB.get_item(item_id, ItemDB.VALUE))
#			item_num = inv.get_item_amount(item_id)
		elif current_mode == Mode.Sell:
			item_num = PlayerInventory.get_item_amount(item_id)
		
		multiple_buy.update_data(0, item_num)
		multiple_buy.show()

func _on_MultipleBuySlider_update_item_amount(new_amount : int):
	self.item_amount = new_amount
