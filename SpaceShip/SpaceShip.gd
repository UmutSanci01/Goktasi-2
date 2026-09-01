extends KinematicBody2D

class_name SpaceShip

#signal shot(kinematic_collision)
signal shot_multi(chunk_list, collision_position, bullet)

onready var node_bullets : Node2D = $Bullets
onready var scene_bullet := preload("res://Bullet/Bullet.tscn")
onready var bullet_manager : Node2D = $BulletPoolManager

#var bullets : Array = []
var bullet_count : int = 0
const size_bullet_pool : int = 50

var selected_bullet_id : int = -1
var bullet : Bullet

func _ready():
	add_to_group("save_data")

	load_data()

	Notification.register_observer(self, Notification.NotificationTypes.BulletTypeChanged)
	
	# var bullet_data = ItemDB.get_item(selected_bullet_id)
	# if bullet_data:
	# 	scene_bullet = bullet_data.scene
	
# 	var bullet : Bullet
# 	for _i in range(size_bullet_pool):
# 		bullet = scene_bullet.instance()
		
# #		if bullet.connect("collision", self, "_on_bullet_collide"): pass
# 		if bullet.connect("collision_meteor", self, "_on_Bullet_MeteorCollide"): pass
		
# 		node_bullets.add_child(bullet)
#		bullets.append(bullet)

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			pass
		else:
			if not GameState.is_bullet_menu_opened:
				fire()
			# DEMO
#			if GameState.screen_safe_area.has_point(event.position):
#				fire()
			# DEMO

func fire():
	if PlayerInventory.use_item(selected_bullet_id):
		# pool_manager.get_bullet(bullet_id)
		# bullet.enable(Vector2.UP, global_position)

		bullet = bullet_manager.get_bullet(selected_bullet_id)
		bullet.enable(Vector2.UP, global_position)
		# node_bullets.get_child(bullet_count).enable(Vector2.UP, global_position)
		# bullet_count = (bullet_count + 1) % size_bullet_pool
	else:
		InfoPanel.add_label("Mermi Kalmadı")


func save_data():
	var data : Dictionary = {
		"bullet_id" : selected_bullet_id
	}
	DataBase.save_data(data, "space_ship")

func load_data():
	var data : Dictionary = DataBase.load_data("space_ship")
	if not data.empty():
		selected_bullet_id = data["bullet_id"]
	else:
		selected_bullet_id = Item.ID.BULLET
	GameState.selected_bullet_id = selected_bullet_id


func _on_Notify(notify_type : int):
	if notify_type == Notification.NotificationTypes.BulletTypeChanged:
		selected_bullet_id = GameState.selected_bullet_id

func _on_Bullet_MeteorCollide(collision_position : Vector2, collide_list : Array, bullet : Bullet):
	emit_signal("shot_multi", collide_list, collision_position, bullet)


func _on_GUI_selected_bullet(bullet_id):
	selected_bullet_id = bullet_id
