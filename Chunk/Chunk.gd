class_name Chunk

extends KinematicBody2D

onready var polygon2d : Polygon2D = $Polygon2D
onready var polygon_collision2d : CollisionPolygon2D = $CollisionPolygon2D

func set_polygon(points : PoolVector2Array):
	polygon2d.polygon = points
	polygon_collision2d.set_deferred("polygon", points)

