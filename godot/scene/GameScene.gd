extends Node2D

onready var dialogue_manager = get_node("DialogueManager")

var dialogue_order = ["Intro_Part1", "Intro_Part2", "Intro_Part3", "Chapter2P1", "Chapter2P2"]

func _ready():
	dialogue_manager.connect("dialogue_finished", self, "load_next_dialogue")
	load_next_dialogue()
	

func load_next_dialogue():
	dialogue_manager.start_dialogue("res://content/dialogue/" + dialogue_order.pop_front() + ".json")

