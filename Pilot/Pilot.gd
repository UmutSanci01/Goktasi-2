extends KinematicBody2D

enum State {
	IDLE,
	WALKING,
	RUNNING,
	ROLLING
}

var current_state = State.IDLE

var speed = 200
var run_speed = speed + 200
var velocity = Vector2()

func _process(delta):
	match current_state:
		State.IDLE:
			handle_input()
		State.WALKING:
			handle_input()
			handle_movement()
		State.RUNNING:
			handle_input()
			handle_movement(run_speed)

func handle_input():
	velocity = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		if Input.is_action_pressed("ui_shift"):  # Koşma
			current_state = State.RUNNING
		else:
			current_state = State.WALKING
	
	if Input.is_action_just_pressed("ui_select"):  # Farenin sağ tıkı (varsayılan "ui_select")
		current_state = State.ROLLING
	
	velocity = velocity.normalized() * speed

func handle_movement(current_speed = speed):
	velocity = velocity.normalized() * current_speed
	move_and_slide(velocity)
	
	if velocity.length() == 0:
		current_state = State.IDLE
	if current_state == State.WALKING and Input.is_action_pressed("ui_shift"):
		current_state = State.RUNNING
