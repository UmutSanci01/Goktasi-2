extends Node


#enum EnumItem {
#	COIN,
#	BULLET,
#	ORE,
#	FUEL,
#	OreDetector,
#	BulletSupplier,
#	FuelSupplier
#}


# ItemType.gd
#enum ItemType {
#	COIN,
#	BULLET,
#	FUEL,
#	ORE,
#	TOOL
#}

enum {
	TYPE,
	NAME,
	INFO,
	SCENE,
	IMAGE,
	VALUE,
	VISIBLE
}


export (Array, Resource) var items_res
var items : Dictionary = {}


func _ready():
	for item in items_res:
		items[item.id] = item


#var items : Dictionary = {
#	EnumItem.COIN : {
#		TYPE : "coin",
#		SCENE: "", 
#		NAME : "Coin", 
#		INFO : "Para",
#		IMAGE: load("res://Images/coin_icon.png"),
#		VALUE: 1,
#		VISIBLE : false
#	},
#	EnumItem.BULLET : {
#		TYPE : "bullet",
#		SCENE: "res://Bullet/Bullet.tscn", 
#		NAME : "Mermi", 
#		INFO : "Normal Mermi",
#		IMAGE: load("res://Images/bullet_red.png"),
#		VALUE: 10,
#		VISIBLE : true
#	},
#	EnumItem.FUEL : {
#		TYPE : "fuel",
#		SCENE: "", 
#		NAME : "Yakıt", 
#		INFO : "Gemi Yakıtı",
#		IMAGE: load("res://Images/fuel_ore.png"),
#		VALUE : 5,
#		VISIBLE : true
#	},
#	EnumItem.ORE : {
#		TYPE : "ore",
#		SCENE : "",
#		NAME : "Maden",
#		INFO : "Maden",
#		IMAGE : load("res://Images/icon_ore.png"),
#		VALUE : 50,
#		VISIBLE : true
#	},
#	EnumItem.OreDetector : {
#		TYPE : "tool",
#		SCENE : "",
#		NAME : "Ore Detector",
#		INFO : "Maden Dedektörü, yakıt kullanarak ışının nüfuz ettiği alandaki maden yoğunluğunu gösterir.",
#		IMAGE : load("res://Images/circuit.png"),
#		VALUE : 4000,
#		VISIBLE : true
#	},
#	EnumItem.BulletSupplier : {
#		TYPE : "tool",
#		SCENE : "",
#		NAME : "Bullet Supplier",
#		INFO : "Mermi üreticisi, madenlerden mermi üretir.",
#		IMAGE : load("res://Images/Gear.png"),
#		VALUE : 5000,
#		VISIBLE : true
#	},
#	EnumItem.FuelSupplier : {
#		TYPE : "tool",
#		SCENE : "",
#		NAME : "Fuel Supplier",
#		INFO : "Yakıt üreticisi, madenlerden yakıt üretir.",
#		IMAGE : load("res://Images/Gear.png"),
#		VALUE : 5000,
#		VISIBLE : true
#	}
#}

var checked_item_id : int = -1
func get_item(item : int = -1) -> Item:
	if item == -1:
		return items.get(checked_item_id)
	return items.get(item)
#	if items.has(item):
#		if data >= 0:
#			return items[item].get(data, false)
#		if data >= 0 and items[item].has(data):
#			return items[item][data]
#		return items[item]


func check_item(item_id : int):
	if items.has(item_id):
		checked_item_id = item_id
		return true
	
	return false
