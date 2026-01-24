extends Node2D


onready var parent : KinematicBody2D = get_parent()

var direction : Vector2 = Vector2.ZERO
var speed : float = 100


func _ready():
	if not parent is KinematicBody2D:
		print_debug("Parent must be KinematicBody2D")
		set_process_input(false)
		set_process_unhandled_input(false)
		set_process_unhandled_key_input(false)


func _process(delta):
	parent.move_and_collide(direction * speed * delta)


func _unhandled_input(event):	
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	else:
		direction = Vector2.ZERO
