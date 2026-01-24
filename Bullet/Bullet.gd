extends KinematicBody2D


class_name Bullet


signal collision_meteor(collision_position, chunk_list)


onready var area_explosive = $AreaExplosive


var speed : int = 500
var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var start_pos : Vector2
var collide : KinematicCollision2D

var collide_list : Array


func _ready():
	disable()


func _physics_process(delta : float):
	velocity = direction * speed
	collide = move_and_collide(delta * velocity)
	
	if collide:
		if collide.collider is Ore:
			GlobalParticles.set_particle(collide.position, Color.yellow)
			collide.collider.mine()
			Notification.notify(Notification.NotificationTypes.OreMined)
		
		elif collide.collider is Chunk:
			collide_list = area_explosive.get_overlapping_bodies()
			emit_signal("collision_meteor", collide.position, collide_list)
		
		disable()


func enable(_direction : Vector2, _position : Vector2):
	direction = _direction
	global_position = _position
	start_pos = _position
	
	show()
	set_physics_process(true)

func disable():
	hide()
	set_physics_process(false)
	
	collide_list.clear()


func _on_Area2D_body_entered(body):
	collide_list.append(body)

