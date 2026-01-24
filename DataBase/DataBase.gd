extends Node2D

signal save_data # Player.gd, Store.gd
signal load_data(load_data)

var data_store_path : String = "user://data"

func _ready():
	var dir : Directory = Directory.new()
	if not dir.dir_exists(data_store_path):
		if dir.make_dir(data_store_path):
			pass

func save_data(p_data, data_owner : String = "data"):
	var file : File = File.new()
	
	if file.open(data_store_path + "/"+ data_owner, File.WRITE):
		pass
	file.store_var(p_data)
	file.close()
	
	emit_signal("save_data")

func load_data(data_owner : String = "data"):
	var data : Dictionary = {}
	var file : File = File.new()
	
	if file.file_exists(data_store_path + "/" + data_owner):
		if file.open(data_store_path + "/" + data_owner, File.READ):
			pass
			
		# Sanirim bu guvenlik aciklarina sebep oluyormus.
		data = file.get_var()
		file.close()
		
		emit_signal("load_data", data)
		
	return data
