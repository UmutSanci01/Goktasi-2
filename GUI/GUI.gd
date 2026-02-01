extends CanvasLayer


class_name GraphicUI


signal quit
#signal settings_change(new_settings)
signal store_buy(item_id, buy_data)


onready var title = $Title
onready var ingame = $InGame
onready var map = $Map
onready var store = $StoreGUI
onready var settings = $Settings


var menu setget set_menu
var stack_menu : Array = []


func _ready():
	for menu in get_children():
		if menu == title: # title don't have return signal
			continue
		menu.hide()
		
		if menu.connect("press_return", self, "_on_press_return"):
			pass
	
	set_menu(title)

func set_menu(next_menu, is_return : bool = false):
	if menu:
		menu.hide()
		if not is_return: stack_menu.append(menu)
	
	menu = next_menu
	menu.show()

func _on_press_return():
	set_menu(stack_menu.pop_back(), true)

func _on_Title_press_start():
	set_menu(ingame)

func _on_Title_press_settings():
	set_menu(settings)

func _on_Title_press_map():
	set_menu(map)

func _on_Title_press_store():
	set_menu(store)

func _on_GUI_Store_buy(item_id, buy_data : Dictionary):
	emit_signal("store_buy", item_id, buy_data)

func _on_Title_press_quit():
	emit_signal("quit")
	get_tree().quit()
