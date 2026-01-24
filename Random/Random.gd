extends Node


var rnd = RandomNumberGenerator.new()
var key = "random"


func _ready():
	add_to_group("save_data")
	
	load_data()


func randomize_rnd():
	rnd.randomize()
	seed(rnd.seed)
	
	save_data()


func save_data():
	var data = {"seed" : rnd.seed}
	
	DataBase.save_data(data, key)


func load_data():
	var data : Dictionary = DataBase.load_data(key)
	if data.empty():
		return
	
	if data.has("seed"):
		rnd.seed = data["seed"]
		seed(rnd.seed)
