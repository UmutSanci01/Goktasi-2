extends Control


func _ready():
	pass

func show():
	.show()

	var bullets = PlayerInventory.get_item_by_type(Item.Type.BULLET)
	print(bullets)
