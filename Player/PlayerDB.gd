extends Node

#class_name PlayerDB

const COIN = "coin"

var data : Dictionary

func _ready():
	pass

func load_data():
	data = {COIN : 500}

func get_data(key : String, specifier : String = ""):
	if not data.has(key):
		return
	
	var temp = data[key]
	
	if not specifier.empty():
		temp = temp[key]
	
	return temp

