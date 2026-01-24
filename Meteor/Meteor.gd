class_name Meteor


signal destroyed()


extends Node2D

export (int, 3, 128) var num_segments : int = 18
export (int, 8, 500) var radius : int = 64
export (int, 1, 400) var num_ore : int = 5
export (bool) var is_rotate = true

onready var chunks = $Chunks
onready var ores : Ores = $Ores

onready var polygon_explosive = $Explosive
onready var polygon_meteor_background = $Bacground

var chunk_num : int = 0

var is_created : bool = false
var is_settings_change : bool = false

var clip_polygon : Array
var explosive_local_points : PoolVector2Array

# save and load variables
var key = "meteor"
var key_radius = "radius"

var data : Map.Data setget set_data
var old_data : Map.Data

# animations
onready var animplayer = $AnimationPlayer
var meteor_pos : Vector2
var tween_out : Tween = Tween.new()
var tween_in : Tween = Tween.new()


func _ready():
#	add_to_group("save_data")
	
	set_physics_process(is_rotate)
	
	meteor_pos = self.position
	
	add_child(tween_out)
	add_child(tween_in)
	tween_out.connect("tween_all_completed", self, "_on_TweenOut_completed")
	tween_in.connect("tween_all_completed", self, "_on_TweenIn_completed")
	
	polygon_explosive.polygon = PolygonMath.calc_circle_points(8, 32)
	explosive_local_points = polygon_explosive.polygon

	polygon_explosive.hide()


func _physics_process(delta):
	rotate(delta)



#func collision(kinematic_collision : KinematicCollision2D):
#	explode(kinematic_collision)


func init_meteor(is_new : bool = true):
	if is_new == false:
		pass
#		if not load_data():
#			data = Map.Data.new()
#
#			data.radius = radius
#			data.ore_num = num_ore
	
	if not data:
		return
	
	if chunks.get_child_count():
		chunks.clear_chunks()
	
	var meteor_points : PoolVector2Array = PolygonMath.calc_circle_points(num_segments, data.radius)
	polygon_meteor_background.polygon = meteor_points
	
	
	# Meteor daha önce ziyaret edilmişse
	if data.polygons.size() > 0:
		chunks.add_chunks_from_array(data.polygons)
	
	elif data.is_destroyed == false: # Meteor ilk defa ziyaret ediliyorsa
		var meteor_main_chunks : Array = []
		var triangle : PoolVector2Array = []
		var triangulated
#		var triangulated = Geometry.triangulate_delaunay_2d(meteor_points)
		
		
		# Meteor ortasinda tek bir buyuk ucgen olmasin diye onceden 4 parcaya boluyoruz
		var main_chunk : PoolVector2Array
		for i in len(meteor_points) / 3:
			main_chunk = []
			for n in range(0, 4):
				var index = ((i*3) + n) % len(meteor_points)
				main_chunk.append(meteor_points[index])
			main_chunk.append(Vector2.ZERO)
			
			meteor_main_chunks.append(main_chunk)
		
		# Onceden boldugumuz 4 parcayi tekrar parcaliyoruz.
		for chunk in meteor_main_chunks:
			if data.radius < 196:
				chunks.add_chunk(chunk)
			else:
				triangulated = Geometry.triangulate_polygon(chunk)
				if not triangulated:
					continue
				
				for i in len(triangulated) / 3:
					triangle = []
					for j in range(3):
						triangle.append(chunk[triangulated[i * 3 + j]])
					
					chunks.add_chunk(triangle)
				
		
		
#		for i in len(triangulated) / 3:
#			triangle = []
#
#			for n in range(3):
#				triangle.append(meteor_points[triangulated[(i * 3) + n]])
##
##				triangle_triangulated = Geometry.triangulate_delaunay_2d(triangle)
##				if triangle_triangulated:
##					for j in len(triangle_triangulated) / 3:
##						triangle_small = []
##						for m in 3:
##							triangle_small.append(triangle[triangle_triangulated[(j * 3) + m]])
##
##
##						chunks.add_chunk(triangle_small)
##			else:
#			chunks.add_chunk(triangle)
			
#			var poly = Polygon2D.new()
#			chunks.add_child(poly)
#
#			poly.polygon = triangle
##			poly.color = Color.red
#
#			poly.color = Color(randf(), randf(), randf())
		
#		chunks.add_chunk(meteor_points)
#		chunks.add_chunks_from_array(meteor_triangles)
	
#	elif data.is_chunks_destroyed == false:
#		if is_new == false:
#			chunks.init()
#		else:
#			chunks.add_chunk(meteor_points)
	
	if data.ores.size() > 0 and data.ores.size() == data.ore_ids.size():
		ores.add_ores_from_array(data.ores, data.ore_ids)
	elif data.is_ores_collected == false:
		ores.init_ores(is_new)
	else:
		ores.clear_ores()
	
	
	save_data()


func drop_chunk(_chunk_points : PoolVector2Array):
	pass


func explode(chunk : Chunk, collision_position : Vector2):
	if not chunk:
		return
	
	# Move explosive polygon to new position. Then, add the new position to every polygon dots.
	polygon_explosive.global_position = collision_position
	for i in range(explosive_local_points.size()):
		explosive_local_points[i] = polygon_explosive.polygon[i] + polygon_explosive.position
	
	clip_polygon = Geometry.clip_polygons_2d(
		chunk.polygon2d.polygon, explosive_local_points
	)
	
	if clip_polygon.size() == 0:
		if chunk.is_inside_tree():
			chunks.remove_child(chunk)
		else:
			chunk.call_deferred("queue_free")
	
		if chunks.get_child_count() == 0: # When meteor is destroy
			data.is_destroyed = true
#			emit_signal("destroyed")

	# clip polygon size birden buyukse dongu icinde yeni parcalar ekleniyor.
	chunk_num = chunks.get_child_count()
	var clip_polygon_size : int = clip_polygon.size()
	
	for i in range(clip_polygon_size):
		# if polygon is inner then pass
		if not Geometry.is_polygon_clockwise(clip_polygon[i]):
			if i == 0:
				chunk.set_polygon(clip_polygon[i])
			elif i > 0:
				chunks.add_chunk(clip_polygon[i])
	
	save_polygons()


func set_meteor_polygon(points : PoolVector2Array, is_update_back : bool = false):
#	polygon_meteor.polygon = points
#	polygon_collision.polygon = points
	
	if is_update_back:
		polygon_meteor_background.polygon = points


#func new_settings(settings : Dictionary):
#	if settings.has("side_num"):
#		num_segments = settings["side_num"]
#		is_settings_change = true
#	if settings.has("radius"):
#		radius = settings["radius"]
#		is_settings_change = true
#	if settings.has("ore_num"):
#		num_ore = settings["ore_num"]
#		is_settings_change = true
#
#	if is_settings_change:
#		init_meteor()
#		is_settings_change = false


#func set_data(new_data : Map.Data):
#	data = new_data
#
#	anim_exit_screen()


func save_ores():
	var positions = ores.collect_ores_positions()
	var ids = ores.collect_ore_ids()
	data.ores = positions
	data.ore_num = positions.size()
	data.ore_ids = ids
	
	if data.ore_num == 0:
		data.is_ores_collected = true
		InfoPanel.add_label("Maden Kalmadı", "", Color.red)


func save_polygons():
	data.polygons = chunks.collect_chunks_polygons()


func save_data():
	save_ores()
	save_polygons()


func set_data(new_data : Map.Data):
	old_data = data
	data = new_data
	
	if GameState.meteor:
		Notification.notify(Notification.NotificationTypes.SetMeteor)
	
	anim_exit_screen()


func anim_exit_screen():
	if not old_data:
		init_meteor()
		return
	
	var bottom : Vector2 = get_viewport_rect().size
	bottom.y += old_data.radius
	bottom.x = 0
	
#	init_meteor()
	tween_out.interpolate_property(self, "position", self.position, bottom, 1)
	tween_out.start()

func anim_enter_screen():
	var mid : Vector2 = get_viewport_rect().get_center()
	var up : Vector2 = Vector2(meteor_pos.x, -mid.y)
	up.y -= data.radius
	
	tween_in.interpolate_property(self, "position", up, meteor_pos, 1)
	tween_in.start()
	
#	self.position = meteor_pos
#	animplayer.play("scale")


func _on_TweenOut_completed():
	init_meteor()
	
	anim_enter_screen()

func _on_TweenIn_completed():
	pass

func _on_Meteor_destroyed():
	data.is_chunks_destroyed = true
#	data.is_destroyed = true
