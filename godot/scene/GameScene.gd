extends Control

onready var dialogue_manager = get_node("DialogueManager")
onready var image_manager = get_node("ImageManager")
onready var intro_battle : PackedScene = preload("res://battle/IntroBattle.tscn")
onready var pause_menu : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
onready var resume_button : Button 
onready var back_to_title_button : Button
onready var tween = get_node("Tween")

var intro_scene : Node
var pause_scene : Node

var paused : bool = false

signal back_to_title
signal end_of_dialog

var dialogue_order = ["Intro_Part1", "Intro_Part2", "Intro_Part3", "Chapter2P1", "Chapter2P2", "Chapter2P3", "Chapter3", "Chapter4", "BossfightBeginning"]

func _ready():
	dialogue_manager.connect("dialogue_finished", self, "load_next_dialogue")
	load_next_dialogue()
	dialogue_manager.connect("dialogue_signal", self, "load_image")

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
	SoundController.stop_all()
	emit_signal("back_to_title")

func load_image(image_name : String):
	image_manager.load_image(image_name)

var in_animation = false

func load_next_dialogue():
	if in_animation:
		return
	
	in_animation = true
	
	var tmp = dialogue_order.pop_front()
	if tmp == "Intro_Part1":
		intro_scene = intro_battle.instance()
		add_child(intro_scene)
		SoundController.play_music("Start_the_clock_alternate_version.mp3", 0)
		dialogue_manager.modulate = Color(1, 1, 1, 0)
		dialogue_manager.change_box_style("Dialogue")
		
		yield(get_tree().create_timer(2.4), "timeout")
		tween.interpolate_property(dialogue_manager, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.9)
		tween.start()
		yield(tween, "tween_all_completed")
	elif tmp == "Intro_Part2":
		dialogue_manager.modulate = Color(1, 1, 1, 0)
		dialogue_manager.change_box_style("Stage")
		
		tween.interpolate_property(intro_scene, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.4)
		tween.start()
		yield(tween, "tween_all_completed")
		
		intro_scene.queue_free()
		SoundController.play_music("Time_flows_new.mp3", 1, -100)
		SoundController.crossfade_music_channels(0,1)
		
		tween.interpolate_property(dialogue_manager, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.4)
		tween.start()
		yield(tween, "tween_all_completed")
	elif tmp == "BossfightBeginning":
		SoundController.play_music("Start_the_clock.mp3", 0, -100)
		SoundController.crossfade_music_channels(1,0)
	elif tmp == null:
		emit_signal("end_of_dialog")
		return
	
	dialogue_manager.start_dialogue("res://content/dialogue/" + tmp + ".json")
	in_animation = false
