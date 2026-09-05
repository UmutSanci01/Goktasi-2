extends CanvasLayer

onready var text_label : RichTextLabel = $Control/RichTextLabel

# Always append new entries to the end of the enum.
# Inserting items in the middle will shift enum values and invalidate existing save files.
enum Tutors {
	MAIN_MENU, INGAME, INVENTORY, MARKET, MAP, SETTINGS
}

var tutorial_progress_temp : Dictionary = {
    Tutors.MAIN_MENU : false,
	Tutors.INGAME : false,
    Tutors.INVENTORY : false,
    Tutors.MARKET : false,
    Tutors.MAP : false,
	Tutors.SETTINGS : false
}
var tutorial_progress : Dictionary = {}

var current_tutor = Tutors.MAIN_MENU

func _ready():
	add_to_group("save_data")

	tutorial_progress = tutorial_progress_temp.duplicate()
	load_data()

	hide()

func reset():
	tutorial_progress = tutorial_progress_temp.duplicate()
	InfoPanel.add_label("KEY_TUTOR_RESET")

func tutor_show(tutor_id : int):
	if tutorial_progress.get(tutor_id, true): return
	current_tutor = tutor_id

	match current_tutor:
		Tutors.MAP:
			text_label.text = tr("KEY_TUTOR_MAP")
		Tutors.INGAME:
			text_label.text = tr("KEY_TUTOR_INGAME")
		Tutors.INVENTORY:
			text_label.text = tr("KEY_TUTOR_INVENTORY")
		Tutors.MARKET:
			text_label.text = tr("KEY_TUTOR_MARKET")
		Tutors.SETTINGS:
			text_label.text = tr("KEY_TUTOR_SETTINGS")
		_:
			pass

	show()

func _on_ConfirmButton_pressed():
	tutorial_progress[current_tutor] = true
	hide()

func save_data():
	DataBase.save_data(tutorial_progress, "Tutorial")

func load_data():
	var data : Dictionary = DataBase.load_data("Tutorial")
	if not data.empty():
		tutorial_progress.clear()
		for key in data.keys():
			tutorial_progress[int(key)] = data[key]