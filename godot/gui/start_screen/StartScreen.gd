extends Node

onready var v_box_container : VBoxContainer = get_node("VBoxContainer")
onready var start_button: Button = get_node("VBoxContainer/StartButton")
onready var option_button: Button = get_node("VBoxContainer/OptionButton")
onready var credit_button: Button = get_node("VBoxContainer/CreditButton")
onready var quit_button: Button = get_node("VBoxContainer/QuitButton")

signal start_button_pressed
signal credits_button_pressed

func _ready():
	quit_button.visible = OS.get_name() != "HTML5"
	start_button.connect("pressed", self, "_on_StartButton_pressed")
	option_button.connect("pressed", self, "_on_OptionButton_pressed")
	credit_button.connect("pressed", self, "_on_CreditButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")
	#yield(get_tree().create_timer(3), "timeout")

func _on_StartButton_pressed():
	emit_signal("start_button_pressed")

func _on_OptionButton_pressed():
	print("Option")
	
func _on_CreditButton_pressed():
	emit_signal("credits_button_pressed")
	
func _on_QuitButton_pressed():
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
