extends Control

onready var back_button: Button = get_node("VBoxContainer/BackButton")
onready var option_button: OptionButton = get_node("VBoxContainer/OptionButton")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal back_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.connect("pressed", self, "_on_BackButton_pressed")
	option_button.connect("item_selected", self, "_on_OptionButton_pressed")
	option_button.add_item("English", 0)
	option_button.add_item("German", 1)
	pass # Replace with function body.

func _on_OptionButton_pressed(ID : int):
	Globals.reset_all_languages()
	if ID == 0:
		Globals.language["English"] = true
	elif ID == 1:
		Globals.language["German"] = true

func _on_BackButton_pressed():
	emit_signal("back_button_pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
