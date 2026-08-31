class_name PolygonMath


static func get_area(points : PoolVector2Array) -> float:
	var is_clockwise : bool = Geometry.is_polygon_clockwise(points)
	var points_size : int = points.size()
	var ii : int
	var area : float = 0
	for i in range(points_size):
		ii = (i + 1) % points_size
		
		if is_clockwise:
			area += (points[ii].x * points[i].y) - (points[i].x * points[ii].y)
		else:
			area += (points[i].x * points[ii].y) - (points[ii].x * points[i].y)
	
	return area / 2

# Vector2(num_segments, radius) : points
const points_cache : Dictionary = {}
# Example
#	var meteor_points : PoolVector2Array = PolygonMath.calc_circle_points(num_segments, data.radius)
# 	polygon_meteor_background.polygon = meteor_points
static func calc_circle_points(num_segments : int, radius : int) -> PoolVector2Array:
	if radius < 3:
		return PoolVector2Array()
	
	var key : Vector2 = Vector2(num_segments, radius)
	var points : PoolVector2Array = points_cache.get(key, PoolVector2Array())

	if not points.empty():
		return points

	var angle_increment = 360.0 / num_segments
	for i in range(num_segments):
		var angle = deg2rad(angle_increment * i)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	
	points_cache[key] = points
	
	return points
