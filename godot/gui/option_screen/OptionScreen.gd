extends Control

onready var back_button: Button = get_node("VBoxContainer/BackButton")
onready var language_button: OptionButton = get_node("VBoxContainer/LanguageButton")
onready var version_button: OptionButton = get_node("VBoxContainer/VersionButton")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal back_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.connect("pressed", self, "_on_BackButton_pressed")
	language_button.connect("item_selected", self, "_on_LanguageButton_pressed")
	language_button.add_item("English", 0)
	language_button.add_item("German", 1)
	if Globals.language["English"]:
		language_button.select(0)
	elif Globals.language["German"]:
		language_button.select(1)
	version_button.connect("item_selected", self, "_on_VersionButton_pressed")
	version_button.add_item("Normal", 0)
	version_button.add_item("Player Version", 1)
	if !Globals.player_version:
		version_button.select(0)
	else:
		version_button.select(1)
	pass # Replace with function body.

func _on_LanguageButton_pressed(ID : int):
	Globals.reset_all_languages()
	if ID == 0:
		Globals.language["English"] = true
	elif ID == 1:
		Globals.language["German"] = true

func _on_VersionButton_pressed(ID : int):
	if ID == 0:
		Globals.player_version = false
	elif ID == 1:
		Globals.player_version = true

func _on_BackButton_pressed():
	emit_signal("back_button_pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
