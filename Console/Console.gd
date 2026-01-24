extends Node

signal output(out)

#var store_node : Node

var commands : Dictionary = {}
var last_cmd : String = ""
var output
var split_cmd : PoolStringArray


func _ready():
#	add_command(self, "get_player_items")
#	add_command(self, "get_market_items")
	
	add_command(self, "clear")
	add_command(self, "help")
	add_command(self, "quit")
#	add_command(self, "buy_item")
#	add_command(self, "sell_item")


#func _input(event):
#	pass


func add_command(own, cmd_name : String):
	var cmd = {"owner" : own, "ref" : funcref(own, cmd_name)}
	commands[cmd_name] = cmd


func call_cmd(cmd_name : String):
	if not commands.has(cmd_name):
		return false
	
	var cmd : Dictionary = commands[cmd_name]
	var cmd_title_text : String = "> "
	
	if cmd.has("ref"):
		var cmd_owner = cmd.get("owner")
		if not cmd_owner:
			return
		
		
		var cmd_ref : FuncRef = cmd["ref"]
		if not cmd_owner.has_method(cmd_ref.function):
			return
		
		cmd_title_text += cmd_owner.name + " "
		cmd_title_text += cmd_ref.function
		
		ConsoleGUI.push_text_to_hist(cmd_title_text)
		
		var ret = cmd_ref.call_func()
		
		if ret:
			ConsoleGUI.push_text_to_hist(str(ret))
		
		
		last_cmd = cmd_name
		
		return true
	
	return false


func get_last_cmd():
	if len(last_cmd) > 0:
		return last_cmd


#func _on_ConsoleGUI_enter_code(entered_code : String):
#	split_cmd = entered_code.split(" ")
#	if split_cmd.size() == 0:
#		return
#
#	var func_name : String = split_cmd[0]
#	if has_method(func_name):
#		var parameters : Array = []
#		for i in range(1, split_cmd.size()):
#			parameters.append(split_cmd[i])
#
#		output = callv(func_name, parameters)
#		last_cmd = entered_code
#	else:
#		output = "cmd not found"
#	emit_signal("output", output)


#func get_player_items():
#	var player_items = PlayerInventory.items
#
#	var items = []
#	for i in player_items:
#		var item = []
#		item.resize(2)
#
#		item[0] = ItemDB.get_item(i, ItemDB.NAME)
#		item[1] = PlayerInventory.get_item_amount(i)
#
#		items.append(item)
#
#	var text = ConsoleGUI.array_to_text(items)
#	ConsoleGUI.push_text_to_hist(text)
	

#func get_market_items():
#	var store_items = Store.inv.items
#
#	var items = []
#	for i in store_items:
#		var item = []
#		item.resize(2)
#
#		item[0] = ItemDB.get_item(i, ItemDB.NAME)
#		item[1] = Store.inv.get_item_amount(i)
#
#		items.append(item)
#
#	var text = ConsoleGUI.array_to_text(items)
#	ConsoleGUI.push_text_to_hist(text)


#func buy_item():
#	Store.buy(ItemDB.EnumItem.BULLET, 10, PlayerInventory)
#	get_player_items()
#
#func sell_item():
#	Store.sell(ItemDB.EnumItem.BULLET, 10, PlayerInventory)
#	get_player_items()


func help():
	var cmd_owner : Node
	var cmd_ref : FuncRef
	for cmd_name in commands:
		var cmd = commands.get(cmd_name)
		cmd_owner = cmd.get("owner")
		cmd_ref = cmd.get("ref")
		
		if cmd_owner and cmd_ref:
			var text_array : PoolStringArray
			var text : String
			
			text_array.append(cmd_ref.function)
			text_array.append(cmd_owner.name)
			
			text = ConsoleGUI.array_to_text(text_array)
			
			ConsoleGUI.push_text_to_hist(text)


func quit():
	get_tree().quit()


#func add_item(p_item_id : String, inventory : String, amount : String):
#	var item_id = p_item_id.to_int()
#	var item_amount = amount.to_int()
#	if item_id < 0:
#		return "item not found"
#	if not item_amount:
#		item_amount = 1
#
#	if inventory == "player":
#		PlayerInventory.add_item(item_id, item_amount)
#		return true
#	elif inventory == "market":
#		var store_inv = store_node.get_inv()
#		if store_inv:
#			store_inv.add_item(item_id, item_amount)
#			return true
#		return false
#	else:
#		return "inv not found"



