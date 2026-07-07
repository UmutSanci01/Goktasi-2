extends KinematicBody2D


class_name Bullet


signal collision_meteor(collision_position, chunk_list, bullet)

export (int) var explosive_radius = 16

onready var area_explosive = $AreaExplosive
onready var explosive_polygon = $ExplosivePolygon

var speed : int = 500
var velocity : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var start_pos : Vector2
var collide : KinematicCollision2D

var collide_list : Array


func _ready():
	disable()

	var shape_2d : CircleShape2D = area_explosive.get_node("CollisionShape2D").shape
	shape_2d.radius = explosive_radius

	explosive_polygon.polygon = PolygonMath.calc_circle_points(8, explosive_radius)


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
			emit_signal("collision_meteor", collide.position, collide_list, self)
		
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

