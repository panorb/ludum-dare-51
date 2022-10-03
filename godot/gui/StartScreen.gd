extends Node

onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")
onready var v_box_container : VBoxContainer = get_node("VBoxContainer")
onready var color_rect2 : ColorRect = get_node("ColorRect2")
onready var start_button: Button = get_node("VBoxContainer/StartButton")
onready var option_button: Button = get_node("VBoxContainer/OptionButton")
onready var credit_button: Button = get_node("VBoxContainer/CreditButton")
onready var quit_button: Button = get_node("VBoxContainer/QuitButton")

func _ready():
	quit_button.disabled = OS.get_name() == "HTML5"
	v_box_container.visible = false
	color_rect2.visible = false
	animation_player.play("Fade in")
	yield(animation_player, "animation_finished")
	animation_player.play("Fade Out")
	yield(animation_player, "animation_finished")
	v_box_container.visible = true
	color_rect2.visible = true
	animation_player.play("Fade In Buttons")
	yield(animation_player, "animation_finished")
	start_button.connect("pressed", self, "_on_StartButton_pressed")
	option_button.connect("pressed", self, "_on_OptionButton_pressed")
	credit_button.connect("pressed", self, "_on_CreditButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")
	#yield(get_tree().create_timer(3), "timeout")

func _on_StartButton_pressed():
	print("Start")

func _on_OptionButton_pressed():
	print("Option")
	
func _on_CreditButton_pressed():
	print("Credit")
	
func _on_QuitButton_pressed():
	get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
