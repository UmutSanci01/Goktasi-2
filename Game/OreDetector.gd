extends Area2D


onready var collision = $CollisionShape2D
onready var line = $Line2D


func _ready():
	pass


func init_shape(pos_b : Vector2):
	var shape : SegmentShape2D = get_node("CollisionShape2D").shape
	shape.b = pos_b
	
	init_line(shape.a, -shape.b)


func init_line(a : Vector2, b : Vector2):
	line.add_point(a)
	line.add_point(b)


func disable():
	line.hide()
	collision.set_deferred("disabled", true)

func enable():
	line.show()
	collision.set_deferred("disabled", false)
