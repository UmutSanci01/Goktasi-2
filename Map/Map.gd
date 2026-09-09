extends Node


signal init()
signal curr_slot_changed(curr_slot_index, slot_data)


const MAX_ORE : int = 16
const MAX_RAD : int = 256
const MIN_RAD : int = 64


enum MapLocation {
	METEOR,
	STORE
}


class Data:
	var radius : float
	var ore_num : int
	var texture : Texture
	var index2d : Vector2
	var has_index2d : bool = false
	var is_destroyed : bool = false
	var is_chunks_destroyed : bool = false
	var is_ores_collected : bool = false
	var is_visited : bool = false
	var polygons : Array
	var ores : PoolVector2Array
	var ore_ids : PoolIntArray
	
	var type : int = MapLocation.METEOR


var SLOT_NUM: int = 10
var datas : Dictionary = {}
#var grid_size : int = 0 setget set_grid_size
var current_slot_index : int = -1 setget set_current_slot_index, get_current_slot_index
var old_slot_index : int = -1

# checks
var is_init_datas : bool = false setget set_is_init_datas, get_is_init_datas
var is_init_curr_slot : bool = false
var is_init_grid_size : bool = false

# save load
var key = "map"


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.Reset)
#	GameState.add_reset_group(self)
	
	add_to_group("save_data")
	
	load_data()
	
#	grid_size = SLOT_NUM
	
	if not is_init_grid_size:
		initialize()

	if not is_init_datas:
		init_data()

	if not is_init_curr_slot:
		init_curr_slot()


func initialize(is_new : bool = false):
	Store.is_reachable = false
	
	if is_new:
#		is_init_datas = false
		is_init_curr_slot = false
		SLOT_NUM = int(rand_range(10, 50))
	
	if is_new or datas.size() <= 0:
		init_data()
	if is_new or current_slot_index < 0:
		init_curr_slot()
	
	is_init_datas = true
	is_init_curr_slot = true
	
	emit_signal("init")


func init_curr_slot():
	self.current_slot_index = SLOT_NUM - 1
#	var rnd_slot = select_rand_slot()
#	if rnd_slot >= 0 and rnd_slot < SLOT_NUM:
#		self.current_slot_index = rnd_slot


func init_data():
	datas.clear()
	
	for i in range(SLOT_NUM):
		var data = Data.new()
		
		data.ore_num = (randi() % MAX_ORE) + 1
		data.radius = rand_range(MIN_RAD, MAX_RAD)
		
		datas[i] = data
	
	var data_store = datas[SLOT_NUM - 1]
	data_store.type = MapLocation.STORE

func set_grid_size(size : int):
	SLOT_NUM = size

func set_current_slot_index(slot_index : int):
	old_slot_index = current_slot_index
	current_slot_index = slot_index
	
	var data : Data = get_data(slot_index)
	
	if data.type == Map.MapLocation.STORE:
		Store.is_reachable = true
		
	else:
		Store.is_reachable = false

	data.is_visited = true
	
	emit_signal("curr_slot_changed", current_slot_index, data)


func get_current_slot_index():
	return current_slot_index

func set_is_init_datas(value : bool):
	is_init_datas = value

func get_is_init_datas() -> bool:
	return is_init_datas

func get_data(data_index : int = -1) -> Data:
	return datas.get(data_index)


func select_rand_slot() -> int:
	return randi() % SLOT_NUM


func _on_MapGUI_moved(slot_index : int, slot_dist : int):
	if slot_index == current_slot_index:
		return
	
	# var _slot_data : Data = get_data(slot_index)
	
#	if PlayerInventory.use_item(Item.ID.FUEL, slot_dist):
	if PlayerInventory.use_item_by_type(Item.Type.FUEL, slot_dist):
		set_current_slot_index(slot_index)
	else:
			InfoPanel.add_label("KEY_INSUFFICIENT_FUEL_MAP", "", Color(0.411765, 1, 0.921569))

func save_data():
	var data : Dictionary = {"curr_slot" : current_slot_index, "grid_size" : SLOT_NUM}
	
	for slot_index in datas:
		datas[slot_index] = inst2dict(datas[slot_index])
	
	data["datas"] = datas
	
	DataBase.save_data(data, key)


func load_data():
	var data : Dictionary = DataBase.load_data(key)
	
	if data.has("grid_size"):
		var grid_size = data["grid_size"]
		
		if grid_size:
			SLOT_NUM = grid_size
			is_init_grid_size = true

	if data.has("datas"):
		for slot_index in data["datas"]:
			data["datas"][slot_index] = dict2inst(data["datas"][slot_index])
		
		datas = data["datas"]
		
		if datas.size() > 0:
			is_init_datas = true
	
	
	if data.has("curr_slot"):
		self.current_slot_index = data['curr_slot']
		if current_slot_index >= 0 and current_slot_index < SLOT_NUM:
			is_init_curr_slot = true


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.Reset:
		initialize()