class_name Ores
extends Node2D


onready var meteor = get_parent()
onready var ore_scene = preload("res://Ores/Base/Ore.tscn")


var ore_weights : Dictionary = {
	Item.ID.ORE_COPPER : 100,
	Item.ID.ORE_IRON : 20,
	Item.ID.ORE_SILVER : 1,
	Item.ID.ORE_GOLD : 5
}
var weights_sum = 0
var percent : float = 100


# save and load variables
var key = "ores"
var key_ore_positions = "ore_points"
var key_ore_num = "ore_num"
var key_ore_ids = "ore_ids"


func _ready():
	for weight in ore_weights.values():
		weights_sum += weight
	
	for ore_id in ore_weights:
		# agirliklari yuzdeye ceviriyoruz.
		ore_weights[ore_id] = (ore_weights[ore_id] * percent) / weights_sum


func init_ores(is_new : bool = false):
	var meteor_data = meteor.data
#	if is_new == false:
#		load_data()
#	else:
	clear_ores()
#		randomize()
	
	
	var theta
	var r
	for i in range(meteor_data.ore_num):
		theta = randf() * 2 * PI
		r = randf() + randf()
		if r >= 1:
			r = 2 - r
		
		add_ore(Vector2(r * cos(theta), r * sin(theta)) * meteor_data.radius )
	
	
#	var ore_num : int = meteor_data.ore_num
#	var meteor_radius : float = meteor_data.radius
#	var angle_step = (PI * 2.0) / float(ore_num)
#	var angle = 0
#	var direction : Vector2 = meteor.position
#
#	for _i in range(ore_num):
#		direction.x = cos(angle)
#		direction.y = sin(angle)
#
#		add_ore(direction.normalized() * rand_range(-meteor_radius, meteor_radius))
#
#		angle += angle_step


#func _on_Ore_mined(ore : Ore):
#	if ore:
#		if ore.is_connected("mined", self, "_on_Ore_mined"):
#			ore.disconnect("mined", self, "_on_Ore_mined")
#
#		remove_child(ore)
#		ore.queue_free()
#
#		PlayerInventory.add_item(ItemDB.EnumItem.ORE)


func clear_ores():
	if get_child_count() > 0:
		for child in get_children():
			remove_child(child)


func collect_ores_positions():
	var positions : PoolVector2Array = []
	for child in get_children():
		positions.append(child.position)
	
	return positions


func collect_ore_ids():
	var ids : PoolIntArray = []
	for child in get_children():
		ids.append(child.id)
	
	return ids


func add_ores_from_array(positions : PoolVector2Array, ids : PoolIntArray):
	clear_ores()
	
#	for pos in positions:
#		add_ore(pos)
	for i in range(positions.size()):
		add_ore(positions[i], ids[i])


func add_ore(pos : Vector2, id : int = -1):
	var choosed_id : int
	
	if id > -1:
		choosed_id = id
	else:
		choosed_id = choose_ore()
	
	var item : Item = ItemDB.get_item(choosed_id)
	
#	var ore = ore_scene.instance()
	var ore : Ore = item.scene.instance()
	
	ore.id = choosed_id
	add_child(ore)
	
	ore.position = pos
	
#	if not ore.is_connected("mined", self, "_on_Ore_mined"):
#		ore.connect("mined", self, "_on_Ore_mined")


func choose_ore():
	var random_number = randi() % int(percent) # 0-99 arasında rastgele bir sayı al
	var cumulative = 0
	
	for ore in ore_weights:
		cumulative += ore_weights[ore]
		if random_number < cumulative:
			return ore # Rastgele sayıya göre seçilen eşya
	
	return null # Hiçbir şey seçilmediyse


func save_data():
	var data : Dictionary = {}
	data[key_ore_num] = get_child_count()
	
#	var positions : Array = []
#	for child in get_children():
#		positions.append(child.position)
	data[key_ore_positions] = collect_ores_positions()
	data[key_ore_ids] = collect_ore_ids()
	
	DataBase.save_data(data, key)

func load_data():
	pass
#	var my_data : Dictionary = DataBase.load_data(key)
#	if my_data.has(key_ore_positions):
#		var ore : Ore
#		for pos in my_data[key_ore_positions]:
#			ore = ore_scene.instance()
#			add_child(ore)
#
#			ore.position = pos
