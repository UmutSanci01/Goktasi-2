extends Node2D


class_name Game


signal game_over
signal ore_mined


onready var camera = $Camera2D
onready var ship : SpaceShip = $SpaceShip setget , get_ship
onready var meteor : Meteor = $Meteor setget , get_meteor
onready var ore_detector : Area2D = $OreDetector
onready var supplier_bullet : Supplier = $SupplierBullet
onready var supplier_fuel : Supplier = $SupplierFuel


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.OreMined)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorActive)
	Notification.register_observer(self, Notification.NotificationTypes.OreDetectorDeactive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierBulletActive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierBulletDeactive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierFuelActive)
	Notification.register_observer(self, Notification.NotificationTypes.SupplierFuelDeactive)
	
	get_node("GameArea/CollisionShape2D").shape.extents = OS.get_screen_size()
	
	if Map.connect("curr_slot_changed", self, "_on_Map_curr_slot_changed"): pass
	
	
#	ore_detector.position = ship.position
#	ore_detector.init_shape(ore_detector.position - meteor.position - (Vector2.DOWN * 32))
	
	init()


func init():
	if meteor.connect("destroyed", self, "_on_Meteor_destroyed"): pass
	
	set_meteor_new_data(Map.get_data(Map.current_slot_index))


func set_meteor_new_data(data):
#	if meteor.data:
#		meteor.save_ores()
#		meteor.save_polygons()
	
	meteor.set_data(data)
	
	GameState.meteor = meteor
#	meteor.init_meteor()


func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		pass


func end():
	emit_signal("game_over")


func get_ship():
	return ship

func get_meteor():
	return meteor


func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.OreMined:
		meteor.save_ores()
	
	elif notification_type == Notification.NotificationTypes.MeteorShoted:
		meteor.save_polygons()
	
	elif notification_type == Notification.NotificationTypes.OreDetectorActive:
		ore_detector.enable()
	
	elif notification_type == Notification.NotificationTypes.OreDetectorDeactive:
		ore_detector.disable()
	
	elif notification_type == Notification.NotificationTypes.SupplierBulletActive:
		if supplier_bullet.is_active:
			supplier_bullet.disable()
		else:
			supplier_bullet.enable()
#	elif notification_type == Notification.NotificationTypes.SupplierBulletDeactive:
#		supplier_bullet.disable()
	
	elif notification_type == Notification.NotificationTypes.SupplierFuelActive:
		if supplier_fuel.is_active:
			supplier_fuel.disable()
		else:
			supplier_fuel.enable()
#	elif notification_type == Notification.NotificationTypes.SupplierFuelDeactive:
#		supplier_fuel.disable()


func _on_Meteor_destroyed():
	pass


func _on_BulletTravelLimit_body_entered(body):
	if body is Bullet:
		body.disable()


#func _on_SpaceShip_shot(kinematic_collision : KinematicCollision2D):
#	var collider = kinematic_collision.collider
#	var collision_position : Vector2 = kinematic_collision.position
#
#	if collider is Chunk:
#		meteor.explode(collider, collision_position)
#		GlobalParticles.set_particle(collision_position)
#
#	elif collider is Ore:
#		PlayerInventory.add_item(ItemDB.EnumItem.ORE)
#
#		collider.mine()
#
#		meteor.save_ores()


func _on_GUI_settings_change(new_settings):
	pass
#	meteor.new_settings(new_settings)

func _on_GameArea_body_exited(body):
	# bullet meteora carptigi zaman disable ediliyor. Disable sonucu area bunu exit olarak
	# algiliyor.
	if body is Bullet:
		body.disable()


func _on_Map_curr_slot_changed(_current_slot : int, slot_data : Map.Data):
	set_meteor_new_data(slot_data)


func _on_SpaceShip_shot_multi(chunk_list : Array, collision_position : Vector2):
	for chunk in chunk_list:
		meteor.explode(chunk, collision_position)
		
	GlobalParticles.set_particle(collision_position)


func _on_OreDetector_body_entered(body):
	GameState.detected_ore += 1
	Notification.notify(Notification.NotificationTypes.OreDetected)

	if GameState.detected_ore > 0:
		ore_detector.collision.modulate = Color.green
	else:
		ore_detector.collision.modulate = Color.white


func _on_OreDetector_body_exited(body):
	GameState.detected_ore -= 1
	Notification.notify(Notification.NotificationTypes.OreDetected)
	
	if GameState.detected_ore > 0:
		ore_detector.collision.modulate = Color.green
	else:
		ore_detector.collision.modulate = Color.white
