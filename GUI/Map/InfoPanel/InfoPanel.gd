extends Control

onready var label_ore_num = $PanelContainer/VBoxContainer/OreNum/Value
onready var label_radius = $PanelContainer/VBoxContainer/Radius/Value
onready var label_dist = $PanelContainer/VBoxContainer/Dist/Value

var screen_size : Vector2 = OS.get_screen_size()
var screen_size_half : Vector2 = screen_size / 2

#func _ready():
#	var scale : Vector2
#	scale.x = screen_size.x / 683
#	scale.y = screen_size.y / 768
#	print(screen_size)
#	var size : Vector2
#	size.x = screen_size.x / 4
#	size.y = 128
	
#	$PanelContainer.set_deferred("rect_size", size)
#	set_deferred("rect_scale", scale)

func pop(position : Vector2):
	show()
	
	var direction : Vector2 = Vector2.UP
	var offset : Vector2 = Vector2.ZERO
	
	# position is left
	if position.x < screen_size_half.x:
		direction.x = 1
		offset.x = 64
	else: # is right
		direction.x = -1
		offset.x = $PanelContainer.rect_size.x #* rect_scale.x
	
	# position is up
	if position.y < screen_size_half.y:
		direction.y = 1
		offset.y = 64
	else: # is down
		direction.y = -1
		offset.y = $PanelContainer.rect_size.y #* rect_scale.y
	
	rect_position = position + (offset * direction)

func set_data(ore_num : int, radius : float, dist : int):
	label_ore_num.text = str(ore_num)
	label_radius.text = str(radius)
	label_dist.text = str(dist)
