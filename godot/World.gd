extends Node

onready var scenes = get_node("Scenes")
var final_battle : PackedScene = preload("res://battle/FinalBattle.tscn")
var start_screen : PackedScene = preload("res://gui/start_screen/StartScreen.tscn")
var developer_screen : PackedScene = preload("res://gui/developerscreen/DeveloperScreen.tscn")
var pause_screen : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
var game_screen : PackedScene = preload("res://scene/GameScene.tscn")
var end_screen : PackedScene = preload("res://scene/EndScene.tscn")
var credits_scene : PackedScene = preload("res://gui/credits/CreditsScene.tscn")
var current_scene : Node

func _ready():
	change_scene(developer_screen)
	# current_scene.connect("back_to_title_button_pressed", self, "change_scene", [start_screen])
	#start_screen_instance.connect("start_button_pressed", self, "change_scene", game_scene)
	#add_child(pause_screen.instance())
	# add_child(final_battle.instance())
	# i = "hallo"

func start_game():
	change_scene(game_screen)

func open_credits():
	change_scene(credits_scene)

func back_to_title():
	change_scene(start_screen)

func start_endfight():
	SoundController.load_music("Time_is_running_out.mp3", 1)
	SoundController.crossfade_music_channels(0,1)
	SoundController.play_channel(1)
	change_scene(final_battle)
	
func end_of_game(value : bool):
	SoundController.stop_all()
	change_scene(end_screen)
	current_scene.win = value

func change_scene(scene : PackedScene):
	if current_scene:
		current_scene.queue_free()
	current_scene = scene.instance()
	add_child(current_scene)
	
	if current_scene.has_signal("start_button_pressed"):
		current_scene.connect("start_button_pressed", self, "start_game")
	if current_scene.has_signal("credits_button_pressed"):
		current_scene.connect("credits_button_pressed", self, "open_credits")
	if current_scene.has_signal("back_to_title"):
		current_scene.connect("back_to_title", self, "back_to_title")
	if current_scene.has_signal("go_to_start_screen"):
		current_scene.connect("go_to_start_screen", self, "back_to_title")
	if current_scene.has_signal("end_of_dialog"):
		current_scene.connect("end_of_dialog", self, "start_endfight")
	if current_scene.has_signal("end_of_battle"):
		current_scene.connect("end_of_battle", self, "end_of_game")

# Wird jedes Idleframe aufgerufen (Normalerweise 60x die Sekunde, kann aber auch weniger)
func _process(delta):
	pass

# Wird 60x die Sekunde aufgerufen (Wenn das Spiel langsam ist - 
func _physics_process(delta):
	pass
