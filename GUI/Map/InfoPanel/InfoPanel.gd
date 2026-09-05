extends Control

onready var label_ore_num = $PanelContainer/VBoxContainer/OreNum/Value
onready var label_radius = $PanelContainer/VBoxContainer/Radius/Value
onready var label_dist = $PanelContainer/VBoxContainer/Dist/Value

#var screen_size : Vector2 = OS.get_screen_size()
#var screen_size : Vector2 = OS.get_real_window_size()
#var screen_size : Vector2 = OS.window_size
var screen_size : Vector2
var screen_size_half : Vector2

#func _draw():
#	draw_circle(screen_size_half, 10, Color.purple)
#	draw_circle(screen_size, 10, Color.red)

func _ready():
	screen_size = get_viewport_rect().size
	screen_size_half = screen_size / 2
	
#	show()
#	var scale : Vector2
#	scale.x = screen_size.x / 683
#	scale.y = screen_size.y / 768
#	print(screen_size)
#	var size : Vector2
#	size.x = screen_size.x / 4
#	size.y = 128
	
#	$PanelContainer.set_deferred("rect_size", size)
#	set_deferred("rect_scale", scale)

func pop(base_pos: Vector2, slot_scaled_size: Vector2) -> void:
	show()
	
	var direction: Vector2 = Vector2.ONE
	var offset: Vector2 = Vector2.ZERO
	
	# X Ekseni Kontrolü
	if base_pos.x < screen_size_half.x:
		direction.x = 1
		offset.x = slot_scaled_size.x # Slot ekranın solundaysa paneli slotun genişliği kadar sağa it
	else:
		direction.x = -1
		offset.x = $PanelContainer.rect_size.x # Slot sağdaysa paneli kendi genişliği kadar sola çek
	
	# Y Ekseni Kontrolü
	if base_pos.y < screen_size_half.y:
		direction.y = 1
		offset.y = slot_scaled_size.y # Slot ekranın üstündeyse paneli slotun yüksekliği kadar aşağı it
	else:
		direction.y = -1
		offset.y = $PanelContainer.rect_size.y # Slot altındaysa paneli kendi yüksekliği kadar yukarı çek
	
	rect_position = base_pos + (offset * direction)

func set_data(ore_num : int, radius : float, dist : int):
	label_ore_num.text = str(ore_num)
	label_radius.text = str(radius)
	label_dist.text = str(dist)
