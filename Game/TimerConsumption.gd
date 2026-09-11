class_name TimerConsumption
extends Timer

onready var fuel_timer: Timer = self

export var base_interval: float = 10.0
export var soft_capacity: float = 100
export var min_interval: float = 0.1 # Safety limit for Game Engine


func _ready():
	if PlayerInventory.connect("update_inv", self, "update_fuel_consumption"): pass
	if fuel_timer.connect("timeout", self, "_on_FuelTimer_timeout"): pass
	if Upgrade.connect("engine_upgraded", self, "_on_EngineUpgraded"): pass

	calc_base_interval()
	update_fuel_consumption()
	fuel_timer.start()

func update_fuel_consumption() -> void:
	var total_items : int = PlayerInventory.total_amount
	var load_ratio: float = float(total_items) / soft_capacity
	var new_interval: float = base_interval / (1.0 + pow(load_ratio, 2.0))

	InfoPanel.add_label("Total amount:", total_items)
	
	new_interval = max(new_interval, min_interval)
	
	var old_time_left = fuel_timer.time_left
	fuel_timer.wait_time = new_interval
	
	if not fuel_timer.is_stopped() and old_time_left > new_interval:
		fuel_timer.start(new_interval)
	elif fuel_timer.is_stopped() and PlayerInventory.has_item(Item.Type.FUEL, true):
		fuel_timer.paused = false
		fuel_timer.start(new_interval)

func calc_base_interval():
	soft_capacity = 500 + (Upgrade.engine_tier * 400) + (pow(Upgrade.engine_tier, 2) * 200)
	base_interval = 10.0 + (Upgrade.engine_tier * 2.5)

func _on_EngineUpgraded(_new_tier : int):
	calc_base_interval()
	update_fuel_consumption()

func _on_FuelTimer_timeout():
	if not PlayerInventory.use_item_by_type(Item.Type.FUEL):
		fuel_timer.stop()