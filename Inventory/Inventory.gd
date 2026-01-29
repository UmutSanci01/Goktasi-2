extends Node

class_name Inventory

signal update_inv

# item_id : item_amount
var items : Dictionary = {}
var owner_name : String = ""


class WrapSameType:
	var items : Dictionary = {} # item_id : item_amount
	var total : int = 0


func _init(p_owner_name : String = "Envanter"):
	owner_name = p_owner_name


func _ready():
	yield(get_tree().current_scene, "ready")
	emit_signal("update_inv")
	

func add_item(item, amount : int = 1):
	if amount <= 0:
		return
	
	if items.has(item):
		items[item] += amount
	else:
		items[item] = amount
	emit_signal("update_inv")


func del_item(item, amount : int = 1, clear : bool = false) -> bool:
	if not items.has(item):
		return false
	
	var item_num : int = items[item]
	
	if clear:
		if items.erase(item): pass
	elif item_num <= amount:
		if items.erase(item): pass
	else:
		item_num -= amount
		items[item] = item_num
	
	emit_signal("update_inv")
	return true


func set_items(new_items : Dictionary):
	items = new_items
	emit_signal("update_inv")

func get_item_amount(item_id : int):
	if has_item(item_id):
		return items[item_id]
	return 0

func get_item_amount_by_type(item_type : int) -> int:
	var wrap : WrapSameType = get_item_by_type(item_type)
	return wrap.total

func has_item(item, by_type : bool = false):
	if by_type: # Eger turune gore kontrol istenirse
		for id in items:
			var _item = ItemDB.get_item(id)
			if _item and _item.type == item:
				# Envanterdeki esyalardan herhangi birisinin
				# turu istenen ile uyusursa true doner
				return true
	elif items.has(item):
		return true
	
	return false

# Returning items that share same types with amounts and total sum.
func get_item_by_type(item_type : int) -> WrapSameType:
	var same_items : WrapSameType = WrapSameType.new()
	
	for item_id in items:
		var item_ : Item = ItemDB.get_item(item_id)
		if item_:
			if item_.type == item_type:
				same_items.items[item_id] = items[item_id]
				same_items.total += items[item_id]
	
	return same_items

func use_item(item, amount : int = 1) -> int:
	if item == Item.ID.FUEL:
		pass
	var item_ref = ItemDB.get_item(item)
	
#	if item_ref.type == Item.Type.FUEL and GameState.is_free_travel:
#		return 1

	var item_num : int = 0
	var used_num : int = 0
	if amount == 0:
		return used_num
	
	if not items.has(item):
		return used_num
	
	item_num = items[item]
	
	# esyadan yeteri kadar varsa istenen kadar kullandim
	if item_num >= amount:
		item_num -= amount
		used_num = amount
		
		# tukenen esyayi temizledim
		if item_num <= 0:
			if items.erase(item): pass
		else:
			items[item] = item_num
	# aynı türdeki eşyaların toplam sayısına baktım
		# öncelikle talep edilen eşyayı kullanıyor
	
	emit_signal("update_inv")
	
	return used_num

func use_item_by_type(item_type : int, amount : int = 1) -> int:
	if item_type == Item.Type.FUEL and GameState.is_free_travel: return 1
	
	var wrap : WrapSameType = get_item_by_type(item_type)
	if wrap.total == 0: return 0
	if wrap.total < amount: return 0
	
	var used_amount : int = 0
	var temp_amount : int = amount
	for item_id in wrap.items:
		var item_amount = wrap.items[item_id]
		if (temp_amount - item_amount) <= 0:
			used_amount = use_item(item_id, temp_amount)
			break
		else:
			used_amount += use_item(item_id, item_amount)
		
		# used amount is not enough for item_id continue checking
		temp_amount -= item_amount
	
	return used_amount

func check_item(item, amount : int = 1):
	if not has_item(item):
		return false
	
	var item_num = get_item_amount(item)
	
	if item_num < amount:
		return false
	
	return true
