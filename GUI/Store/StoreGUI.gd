extends Control


signal press_return


onready var invpanel_player = $VBoxContainer/HSplitContainer/PlayerInv
onready var invpanel_store = $VBoxContainer/HSplitContainer/StoreInv
onready var btn_action = $VBoxContainer/Buttons/HBoxContainer/Action
onready var btn_activate = $VBoxContainer/Buttons/HBoxContainer/Activate
onready var txt_info = $VBoxContainer/PanelContainer/Infos/ItemInfo
onready var label_value = $VBoxContainer/PanelContainer/Infos/VBoxContainer/ItemValue/Value
onready var multiple_slider : HBoxContainer = $VBoxContainer/Buttons/HBoxContainer/Action/MultipleBuySlider


enum ActionMode {
	Buy,
	Sell
}

var mode = ActionMode.Buy setget set_act_mode
var current_slot : Slot = null
var item_id : int = -1
var item_data : Item

var item_amount_store : int = 1
var item_amount_inv : int = 0


func _ready():
	hide_store()
	multiple_slider.hide()
	
	Store.connect("entered", self, "_on_Store_entered")
	Store.connect("exited", self, "_on_Store_exited")
	
	if Store.is_reachable:
		show_store()
	
	invpanel_player.set_inv(PlayerInventory)
	invpanel_player.set_title("Envanter")
	
	invpanel_store.set_inv(Store.inv)
	invpanel_store.set_title("Market")
	invpanel_store.set_invisible_item(Item.ID.ORE)


func show_store():
	invpanel_store.show()
	btn_action.show()

func hide_store():
	invpanel_store.hide()
	btn_action.hide()


func set_act_mode(new_mode):
	mode = new_mode
	
	var btn_act_atlas : AtlasTexture = btn_action.texture_normal
	btn_act_atlas.region.position.x = mode * 64
	btn_action.texture_normal = btn_act_atlas


func show_info(info : String, item_value : int):
#	var info = ItemDB.get_item(item_id, ItemDB.INFO)
	
	if info.length() > 0:
		txt_info.text = info
	else:
		txt_info.text = "..."
		ConsoleGUI.out(self.name + " show_info item_info not found")
	
	label_value.text = str(item_value)


func update_multbuy():
	var player_coin : int = PlayerInventory.get_item_amount(Item.ID.COIN)
	var item_value : int = item_data.value
	var max_value : int
	
	if item_value <= 0:
		return
	
	if mode == ActionMode.Buy:
		max_value = player_coin / item_value
	elif mode == ActionMode.Sell:
		max_value = self.item_amount_inv
	
	multiple_slider.update_data(self.item_amount_store, max_value)


func _on_Return_pressed():
	multiple_slider.hide()
	
	Player.save_data()
	
	emit_signal("press_return")


func _on_PlayerInv_slot_selected(slot, item_id):
	self.mode = ActionMode.Sell
	self.item_id = item_id
	self.item_data = ItemDB.get_item(item_id)
	self.current_slot = slot
	self.item_amount_inv = PlayerInventory.get_item_amount(item_id)
	
	# Activate button check
	btn_activate.visible = (item_data.type == Item.Type.TOOL)
	
	invpanel_store.hide_slot_indicator()
	show_info(self.item_data.info, self.item_data.value)
	update_multbuy()
	
#	multiple_slider.show()

func _on_StoreInv_slot_selected(slot : Slot, item_id):
	self.mode = ActionMode.Buy
	self.item_id = item_id
	self.item_data = ItemDB.get_item(item_id)
	self.current_slot = slot
	self.item_amount_inv = Store.inv.get_item_amount(item_id)
	
	# Activate button check marketteki esya icin biraz sacma oldu
#	btn_activate.visible = (item_data[ItemDB.TYPE] == "tool")
	btn_activate.hide()
	
	invpanel_player.hide_slot_indicator()
	show_info(self.item_data.info, self.item_data.value)
	update_multbuy()
	
#	multiple_slider.show()


func _on_Action_pressed():
	if not item_data:
		return
	
	if multiple_slider.visible:
		if mode == ActionMode.Buy:
			Store.buy(self.item_id, item_amount_store, PlayerInventory)
			if PlayerInventory.check_item(Item.ID.DETECTOR_ORE):
				GameState.has_player_detector = true
			
		elif mode == ActionMode.Sell:
			self.item_amount_inv = Store.sell(self.item_id, item_amount_store, PlayerInventory)
			if self.item_amount_inv <= 0:
				if item_id == Item.ID.DETECTOR_ORE:
					GameState.is_activate_detector = false
					GameState.has_player_detector = false
				
				self.item_id = -1
	else:
		multiple_slider.show()
	
	update_multbuy()


func _on_Store_entered():
	show_store()

func _on_Store_exited():
	hide_store()


func _on_MultipleBuySlider_update_item_amount(item_amount):
	self.item_amount_store = item_amount


func _on_PlayerInv_press_empty():
	multiple_slider.hide()
	invpanel_player.slot_indicator.hide()
	invpanel_store.slot_indicator.hide()
	
	item_amount_store = 0

func _on_StoreInv_press_empty():
	multiple_slider.hide()
	invpanel_player.slot_indicator.hide()
	invpanel_store.slot_indicator.hide()
	
	item_amount_store = 0


func _on_Activate_pressed():
	if ItemDB.check_item(item_id) == false:
		return
	
	
	if item_id == Item.ID.SUPPLIER_BULLET:
		Notification.notify(Notification.NotificationTypes.SupplierBulletActive)
	elif item_id == Item.ID.SUPPLIER_FUEL:
		Notification.notify(Notification.NotificationTypes.SupplierFuelActive)
	
	elif item_id == Item.ID.DETECTOR_ORE:
		if not PlayerInventory.check_item(Item.ID.DETECTOR_ORE):
			return
		
		if not PlayerInventory.check_item(Item.ID.FUEL):
			InfoPanel.add_label("Yetersiz Yakıt", "", Color.red)
			return
		
		var state : bool = GameState.is_activate_detector
		GameState.is_activate_detector = not state
