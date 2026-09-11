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

	area_explosive.monitoring = true
	area_explosive.monitorable = true

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
			collide_list = _collect_chunk_hits()
			emit_signal("collision_meteor", collide.position, collide_list, self)
		
		disable()


func _collect_chunk_hits() -> Array:
	var hits : Array = []
	
	# Direct physics query for reliable chunk detection
	var space_state = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = explosive_radius
	query.set_shape(circle_shape)
	query.transform = Transform2D(0, global_position)
	query.collision_layer = 16
	
	var results = space_state.intersect_shape(query, 32)
	for result in results:
		var body = result.collider
		if body is Chunk and not hits.has(body):
			hits.append(body)
	
	# Always include the directly collided chunk as fallback
	if collide and collide.collider is Chunk and not hits.has(collide.collider):
		hits.append(collide.collider)
	
	return hits


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

