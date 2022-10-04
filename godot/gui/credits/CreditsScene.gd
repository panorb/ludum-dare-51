extends Control

signal back_to_title

func _ready():
	get_node("%BackToTitleButton").connect("pressed", self, "_on_back_to_title_button_pressed")

func _on_back_to_title_button_pressed():
	emit_signal("back_to_title")
