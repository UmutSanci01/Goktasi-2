extends CanvasLayer


onready var cmd_hist = $PanelContainer/VBoxContainer/ScrollContainer/CmdHistory
onready var cmd_line = $PanelContainer/VBoxContainer/CmdLine




func _ready():
	Console.add_command(self, "clear")
	
	hide()


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_QUOTELEFT:
					change_state()
			
			if visible == false:
				return
			
			match event.scancode:
				KEY_UP:
					var lst_cmd = Console.get_last_cmd()
					if not lst_cmd:
						push_text_to_hist("En son girilen komut yok veya gecersiz.")
						return
					
					cmd_line.clear()
					cmd_line.text = lst_cmd
					
		else: # event.released
			pass


func out(variant):
	push_text_to_hist(str(variant))


func change_state():
	visible = not visible
	if visible:
		cmd_line.call_deferred("grab_focus")


func push_text_to_hist(hist_text : String, newline : bool = true):
	cmd_hist.add_text(hist_text)
	if newline:
		cmd_hist.newline()


func array_to_text(text_array):
	var text : String = ""
	for t in text_array:
		text += str(t) + " "
	
	return text


func clear():
	cmd_hist.clear()


func _on_CmdLine_text_entered(new_text):
	if new_text.empty():
		return
	
	if Console.call_cmd(new_text) == false:
		push_text_to_hist(new_text)
	
	cmd_line.clear()
