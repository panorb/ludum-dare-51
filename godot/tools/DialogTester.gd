extends Control

onready var file_dialog = get_node("FileDialog")
onready var dialogue_manager = get_node("DialogueManager")

func _ready():
	file_dialog.connect("file_selected", self, "_on_file_selected")
	dialogue_manager.connect("dialogue_finished", self, "_dialogue_finished")
	open_file_dialog()

func _dialogue_finished():
	get_tree().change_scene_to(load("res://tools/DialogTester.tscn"))

func open_file_dialog():
	file_dialog.popup_centered()

func _on_file_selected(file):
	dialogue_manager.start_dialogue(file)
