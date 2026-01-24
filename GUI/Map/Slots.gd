extends Control


func clear():
#	if get_child_count() > 0:
	for c in get_children():
		remove_child(c)
		c.queue_free()
