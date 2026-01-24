class_name MyVector

func maxv(v1 : Vector2, v2 : Vector2):
	if v1 > v2:
		return v1
	else:
		return v2


func minv(v1 : Vector2, v2 : Vector2):
	if v1 < v2:
		return v1
	else:
		return v2


func direction_to(v1 : Vector2, v2 : Vector2):
	return maxv(v1, v2) - minv(v1, v2)
