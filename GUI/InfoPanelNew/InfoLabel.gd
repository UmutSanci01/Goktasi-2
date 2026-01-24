class_name InfoLabel
extends HBoxContainer


onready var label_title : Label = $Title
onready var label_value : Label = $Value

# Tek bir script icinde tutulabilir
var seperator : String = " : "

var mid : Vector2


func _ready():
	mid = get_viewport_rect().size / 2
#	label_title.add_color_override("font_color", GameState.color_infolabel_title)


func set_text(title : String, value):
	set_title(title + seperator)
	set_value(value)
#	label_title.text = str(title) + seperator
#	label_value.text = str(value)
	
#	label_value.modulate = Color.gray


func set_title(title):
	label_title.text = str(title)


func set_value(value):
	label_title.align = Label.ALIGN_RIGHT
	label_value.size_flags_horizontal = SIZE_EXPAND_FILL
	label_value.text = str(value)


func _on_Timer_timeout():
	queue_free()
