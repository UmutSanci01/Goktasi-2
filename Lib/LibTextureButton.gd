class_name LibTextureButton


static func has_point(button : Control, position : Vector2) -> bool:
	if not button is TextureButton:
		return false
	if button.get_rect().has_point(position):
		return true
	return false
