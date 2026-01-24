class_name SettingSlider

extends HBoxContainer

signal change_value(data, value)

export (String) var data_name = ""

onready var slider : HSlider = $HSlider
onready var label_value : Label = $Value

func update_data(data):
	slider.value = data
	label_value.text = str(data)

func _on_HSlider_value_changed(value):
	label_value.text = str(value)
	emit_signal("change_value", data_name, value)

func _on_Settings_settings_change(new_settings : Dictionary):
	if new_settings.has(data_name):
		var value = new_settings[data_name]
		label_value.text = str(value)
		slider.value = value
