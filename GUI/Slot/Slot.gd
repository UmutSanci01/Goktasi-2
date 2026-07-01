extends TextureButton

class_name Slot

var item_id : int = -1
#var item_num : int = 0
var indicator : TextureRect

func set_image(image : Texture):
	$ItemImage.texture = image

func set_item(p_item_id : int, p_item_num : int, image : Texture):
	item_id = p_item_id
#	item_num = p_item_num
	
	set_amount(p_item_num)
	
#	indicator_state(false)

	$ItemImage.texture = image

func set_amount(new_amount : int):
	if new_amount > 1:
		$ItemNum.show()
		$ItemNum.text = str(new_amount)
	else:
		$ItemNum.hide()

func get_item() -> int:
	return item_id

func set_indicator(image : Texture):
	indicator = TextureRect.new()

	indicator.texture = image
	indicator.rect_position = self.rect_size * Vector2(0.8, 0.1)

	add_child(indicator)

func indicator_state(state : bool):
	if not indicator: return

	if state:
		indicator.show()
	else: indicator.hide()


func clear_item():
	item_id = -1
#	item_num = 0
	$ItemNum.text = str("")
	$ItemImage.texture = null

func clear_image():
	$ItemImage.texture = null
