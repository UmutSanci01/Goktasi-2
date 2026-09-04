extends CanvasLayer

# APPEND end to the Tutors. Because, maybe index change and save file corruption.
enum Tutors {
	MAIN_MENU, INGAME, INVENTORY, MARKET, MAP
}

var tutorial_progress_temp : Dictionary = {
    Tutors.MAIN_MENU : false,
	Tutors.INGAME : false,
    Tutors.INVENTORY : false,
    Tutors.MARKET : false,
    Tutors.MAP : false
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

func tutor_map():
	if tutorial_progress[Tutors.MAP]: return
	current_tutor = Tutors.MAP

	show()

func _on_ConfirmButton_pressed():
	match current_tutor:
		Tutors.MAP:
			tutorial_progress[Tutors.MAP] = true
		_:
			pass
	hide()


func save_data():
	DataBase.save_data(tutorial_progress, "Tutorial")

func load_data():
	var data : Dictionary = DataBase.load_data("Tutorial")
	if not data.empty():
		tutorial_progress.clear()
		for key in data.keys():
			tutorial_progress[int(key)] = data[key]