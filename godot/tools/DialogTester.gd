extends Control

onready var file_dialog = get_node("FileDialog")
onready var dialogue_manager = get_node("DialogueManager")

func _ready():
	file_dialog.popup_centered()
	file_dialog.connect("file_selected", self, "_on_file_selected")

func _on_file_selected(file):
	file_dialog.hide()
	dialogue_manager.start_dialogue(file)
