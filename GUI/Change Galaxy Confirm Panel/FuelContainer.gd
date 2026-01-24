extends HBoxContainer


onready var label_remain_fuel = $RemainFuel

var remain_fuel : int 


func _ready():
	pass

func set_remain_fuel(remain : int):
	remain_fuel = remain
	
	label_remain_fuel.text = str(remain_fuel)


func _on_ItemAmountLabel_amount_update(new_amount):
	if new_amount < remain_fuel:
		label_remain_fuel.modulate = Color.red
	else:
		label_remain_fuel.modulate = Color.green
