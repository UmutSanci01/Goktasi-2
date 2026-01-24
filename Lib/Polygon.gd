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


static func calc_circle_points(num_segments : int, radius : int) -> PoolVector2Array:
	var points : PoolVector2Array = []
	var angle_increment = 360.0 / num_segments
	
	
	for i in range(num_segments):
		var angle = deg2rad(angle_increment * i)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		points.append(Vector2(x, y))
	
	
	return points
