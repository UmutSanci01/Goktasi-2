extends VSlider

onready var label : Label = get_node("Amount")

func _ready():
	pass


func _on_SliderAmount_value_changed(value):
	label.text = str(value)


func _on_SliderAmount_changed():
	label.text = str(value)
