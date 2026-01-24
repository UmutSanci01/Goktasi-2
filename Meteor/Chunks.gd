extends Node2D

onready var chunk_scene = preload("res://Chunk/Chunk.tscn")

# save and load variables
var key = "chunks"
var key_polygons = "polygons"

func init():
	load_data()

func clear_chunks():
	if get_child_count() > 0:
		for chunk in get_children():
			remove_child(chunk)

func add_chunk(points : PoolVector2Array):
	if points.empty():
		return
	
	var chunk : Chunk = chunk_scene.instance()
	add_child(chunk)
	
#	chunk.polygon2d.color = Color(randf(), randf(), randf())
	
	chunk.set_polygon(points)


func add_chunks_from_array(polygons : Array):
	for polygon in polygons:
		add_chunk(polygon)


func collect_chunks_polygons() -> Array:
	var polygons : Array = []
	for child in get_children():
		polygons.append(child.polygon2d.polygon)
	
	return polygons


func save_data():
	var data : Dictionary = {}
	# storage the polygon of chunks
	var chunk : Chunk
#	var polygons : Array = []
#	for child in get_children():
#		# for type declaration of chunk
#		chunk = child
#		polygons.append(chunk.polygon2d.polygon)
#
	data[key_polygons] = collect_chunks_polygons()
	
	DataBase.save_data(data, key)

func load_data():
	var data : Dictionary = DataBase.load_data(key)
	if data.has(key_polygons):
		if data[key_polygons].size() == 0:
			return
		
		clear_chunks()
		# implementation of the datas
		var chunk : Chunk
		for polygon in data[key_polygons]:
			chunk = chunk_scene.instance()
			add_child(chunk)
			
			chunk.set_polygon(polygon)
