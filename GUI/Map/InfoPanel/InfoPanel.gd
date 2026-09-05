extends Control

onready var label_ore_num = $PanelContainer/VBoxContainer/OreNum/Value
onready var label_radius = $PanelContainer/VBoxContainer/Radius/Value
onready var label_dist = $PanelContainer/VBoxContainer/Dist/Value

var screen_size : Vector2
var screen_size_half : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	screen_size_half = screen_size / 2

func pop(base_pos: Vector2, slot_scaled_size: Vector2) -> void:
	show()
	
	var direction: Vector2 = Vector2.ONE
	var offset: Vector2 = Vector2.ZERO
	
	if base_pos.x < screen_size_half.x:
		direction.x = 1
		offset.x = slot_scaled_size.x
	else:
		direction.x = -1
		offset.x = $PanelContainer.rect_size.x
	
	if base_pos.y < screen_size_half.y:
		direction.y = 1
		offset.y = slot_scaled_size.y
	else:
		direction.y = -1
		offset.y = $PanelContainer.rect_size.y
	
	rect_position = base_pos + (offset * direction)

func set_data(ore_num : int, radius : float, dist : int):
	label_ore_num.text = str(ore_num)
	label_radius.text = str(radius)
	label_dist.text = str(dist)
