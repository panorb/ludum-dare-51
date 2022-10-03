extends Control

onready var dialogue_manager = get_node("DialogueManager")
onready var pause_menu : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
onready var resume_button : Button 
onready var back_to_title_button : Button

var pause_scene : Node

var paused : bool = false

signal back_to_title
signal end_of_dialog

var dialogue_order = []

onready var win : bool setget set_win, get_win

func set_win(value : bool):
	win = value
	if win:
		dialogue_order = ["BossfightWon"]
	else:
		dialogue_order = ["BossfightLost"]
	load_next_dialogue()

func get_win():
	return win
	
func _ready():
	pass

func _input(event):
	if !paused && event.is_action_pressed("pause_menu"):
		pause_scene = pause_menu.instance()
		add_child(pause_scene)
		paused = true
		resume_button = get_node("PauseScreen/VBoxContainer/ResumeButton")
		back_to_title_button = get_node("PauseScreen/VBoxContainer/BackToTitleButton")
		resume_button.connect("pressed", self, "_on_ResumeButton_pressed")
		back_to_title_button.connect("pressed", self, "_on_BackToTitleButton_pressed")

func _on_ResumeButton_pressed():
	pause_scene.queue_free()
	paused = false
	
func _on_BackToTitleButton_pressed():
	pause_scene.queue_free()
	paused = false
	emit_signal("back_to_title")

func load_next_dialogue():
	dialogue_manager.start_dialogue("res://content/dialogue/" + dialogue_order.pop_front() + ".json")
