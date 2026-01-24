extends KinematicBody2D

class_name Ore


#signal mined(ore)
var id : int


func mine():
	get_parent().remove_child(self)
	self.queue_free()
	
	PlayerInventory.add_item(id)
