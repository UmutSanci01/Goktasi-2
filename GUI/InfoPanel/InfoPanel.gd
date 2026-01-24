extends CanvasLayer


onready var animplayer = $AnimationPlayer
onready var label_info = preload("res://GUI/InfoPanelNew/InfoLabel.tscn")
onready var infos = $PanelContainer/Infos
onready var timer = $Timer


func _ready():
	pass


func add_label(title = null, value = null, color = null):
	var label = label_info.instance()
	infos.add_child(label)
	
	if title and value:
		label.set_text(str(title), value)
	
	elif title:
		label.set_title(title)
	elif value:
		label.set_value(value)
	
	if color:
		label.modulate = color
	
	if GameState.is_infopanel_out == false:
		animplayer.play("Out")
		GameState.is_infopanel_out = true
	
	timer.start()


func _on_Timer_timeout():
	animplayer.play_backwards("Out")
	GameState.is_infopanel_out = false


func _on_AnimationPlayer_animation_finished(_anim_name):
	GameState.is_infopanel_completely_out = not GameState.is_infopanel_completely_out
