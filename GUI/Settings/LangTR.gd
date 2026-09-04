extends TextureButton


onready var texture_active : TextureRect = $Active
onready var texture_passive : TextureRect = $Passive


var active : bool = false setget set_active

func _ready():
	add_to_group("save_data")

	load_data()

func set_active(value : bool):
	active = value

	if active:
		activate()
	else:
		deactivate()

func activate():
	texture_active.hide()
	texture_passive.show()
	TranslationServer.set_locale("en")

func deactivate():
	texture_active.show()
	texture_passive.hide()
	TranslationServer.set_locale("tr")

func save_data():
	var data : Dictionary = {
		"active" : active
	}

	DataBase.save_data(data, "LangTR")

func load_data():
	var data : Dictionary = DataBase.load_data("LangTR")
	if data.empty():
		set_active(false)
	else:
		set_active(data["active"])

func _on_LangTR_pressed():
	if active:
		set_active(false)
	else:
		set_active(true)

