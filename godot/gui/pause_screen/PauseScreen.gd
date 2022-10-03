extends Node

onready var resume_button: Button = get_node("VBoxContainer/ResumeButton")
onready var back_to_title_button: Button = get_node("VBoxContainer/BackToTitleButton")

signal back_to_title_button_pressed

func _ready():
	resume_button.connect("pressed", self, "_on_ResumeButton_pressed")
	back_to_title_button.connect("pressed", self, "_on_BackToTitleButton_pressed")
	#yield(get_tree().create_timer(3), "timeout")

func _on_ResumeButton_pressed():
	queue_free()

func _on_BackToTitleButton_pressed():
	emit_signal("back_to_title_button_pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
