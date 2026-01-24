extends KinematicBody2D

class_name SpaceShip

#signal shot(kinematic_collision)
signal shot_multi(chunk_list, collision_position)

onready var node_bullets : Node2D = $Bullets
onready var scene_bullet := preload("res://Bullet/Bullet.tscn")

#var bullets : Array = []
var bullet_count : int = 0
const size_bullet_pool : int = 50

var selected_bullet_id : int = -1


func _ready():
	selected_bullet_id = Item.ID.BULLET
	
	var bullet : Bullet
	for _i in range(size_bullet_pool):
		bullet = scene_bullet.instance()
		
#		if bullet.connect("collision", self, "_on_bullet_collide"): pass
		if bullet.connect("collision_meteor", self, "_on_Bullet_MeteorCollide"): pass
		
		node_bullets.add_child(bullet)
#		bullets.append(bullet)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			fire()


func fire():
	if PlayerInventory.use_item(selected_bullet_id):
		node_bullets.get_child(bullet_count).enable(Vector2.UP, global_position)
		bullet_count = (bullet_count + 1) % size_bullet_pool
	else:
		InfoPanel.add_label("Mermi Kalmadı")


func _on_Bullet_MeteorCollide(collision_position : Vector2, collide_list : Array):
	emit_signal("shot_multi", collide_list, collision_position)


func _on_GUI_selected_bullet(bullet_id):
	selected_bullet_id = bullet_id
