extends CanvasLayer


onready var info_label_pck = preload("res://GUI/InfoPanelNew/InfoLabel.tscn")
onready var lbl_title : Label = $CenterContainer/PanelContainer/VBoxContainer/Title
onready var container_infos = $CenterContainer/PanelContainer/VBoxContainer/Infos


func _on_CenterContainer_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed == true:
			self.hide()


func pop():
	self.show()


func show_message(msg):
	container_infos.hide()
	lbl_title.text = str(msg)
	
	pop()
