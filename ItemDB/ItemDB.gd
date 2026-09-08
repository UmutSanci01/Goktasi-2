extends Node


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


var checked_item_id : int = -1
# if item is not found then return NULL
func get_item(item : int = -1) -> Item:
	if item == -1:
		return items.get(checked_item_id)
	return items.get(item)

func set_item_visible(item_id : int, visible : bool = true):
	var item : Item = get_item(item_id)
	if item:
		item.visible = visible

func set_item_cansale(item_id : int, cansale : bool = true):
	var item : Item = get_item(item_id)
	if item:
		item.can_sale = cansale

func check_item(item_id : int):
	if items.has(item_id):
		checked_item_id = item_id
		return true
	
	return false

func check_item_type_from_id(item_id : int, item_type : int) -> bool:
	var item : Item = get_item(item_id)
	if item and item.type == item_type:
		return true
	return false
