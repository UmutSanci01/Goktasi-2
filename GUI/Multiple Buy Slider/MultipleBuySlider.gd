extends HBoxContainer

signal update_item_amount(item_amount)

onready var slider_amount : VSlider = $SliderAmount

var item_amount : int = 0

func update_data(new_value : int, max_value : int):
	slider_amount.value = new_value
	slider_amount.max_value = max_value


func _on_SliderAmount_value_changed(value):
	item_amount = value
	emit_signal("update_item_amount", item_amount)

func _on_x_pressed(add_num : int):
	if item_amount + add_num <= slider_amount.max_value:
		item_amount += add_num
	else:
		item_amount = int(slider_amount.max_value)
	
	slider_amount.value = item_amount
	emit_signal("update_item_amount", item_amount)

func _on_SliderAmount_changed():
	item_amount = int(slider_amount.value)
