class_name OreDetector
extends Area2D


onready var collision = $CollisionShape2D
onready var line = $Line2D
onready var timer_fuel : Timer = $TimerFuel


func _ready():
	Notification.register_observer(self, Notification.NotificationTypes.SetMeteor)
	GameState.ore_detector = self
	timer_fuel.wait_time = GameState.detector_fuel_cost


func init_shape(pos_a : Vector2, pos_b : Vector2):
	var shape : SegmentShape2D = get_node("CollisionShape2D").shape
	shape.a = pos_a
	shape.b = pos_b
	
	init_line(shape.a, shape.b)

func _on_Notify(notification_type : int):
	if notification_type == Notification.NotificationTypes.SetMeteor:
		if not GameState.ship: return
		
		# # As the detector_str increases, the laser get stronger.
		var ship_pos : Vector2 = GameState.ship.position
		var met_pos : Vector2 = GameState.meteor.position
		var radius : float = GameState.meteor.data.radius
		var deep : float = GameState.detector_str
		var met_outline : Vector2 = Vector2(met_pos.x, met_pos.y + radius)
		var end_point : Vector2 = Vector2(met_outline.x, met_outline.y - (radius * deep))
		init_shape(ship_pos, end_point)

func init_line(a : Vector2, b : Vector2):
	if line.get_point_count() >= 2:
		line.set_point_position(1, b)
	else:
		line.add_point(a)
		line.add_point(b)


func disable():
	line.hide()
	collision.set_deferred("disabled", true)
	
	if timer_fuel.time_left:
		timer_fuel.paused = true
	else:
		timer_fuel.stop()

func enable() -> bool:
	# Resume if there is fuel in the detector or there is fuel in the inventory.
	if not timer_fuel.time_left and not PlayerInventory.use_item_by_type(Item.Type.FUEL):
		InfoPanel.add_label("Yakıt Yok", "", Color.red)
		return false
	
	line.show()
	collision.set_deferred("disabled", false)
	print(timer_fuel.time_left)
	if timer_fuel.time_left:
		timer_fuel.paused = false
	else:
		timer_fuel.start()
	
	return true

func _on_TimerFuel_timeout():
	if not PlayerInventory.use_item_by_type(Item.Type.FUEL):
		timer_fuel.stop()
		GameState.is_activate_detector = false
		InfoPanel.add_label("Yakıt Tükendi", "", Color.red)

