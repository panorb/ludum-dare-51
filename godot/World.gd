extends Node

onready var scenes = get_node("Scenes")
var final_battle : PackedScene = preload("res://battle/FinalBattle.tscn")
var start_screen : PackedScene = preload("res://gui/start_screen/StartScreen.tscn")
var developer_screen : PackedScene = preload("res://gui/developerscreen/DeveloperScreen.tscn")
var pause_screen : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
var game_screen : PackedScene = preload("res://scene/GameScene.tscn")
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

func back_to_title():
	change_scene(start_screen)

func change_scene(scene : PackedScene):
	if current_scene:
		current_scene.queue_free()
	current_scene = scene.instance()
	add_child(current_scene)
	current_scene.connect("start_button_pressed", self, "start_game")
	current_scene.connect("back_to_title", self, "back_to_title")
	current_scene.connect("go_to_start_screen", self, "back_to_title")

# Wird jedes Idleframe aufgerufen (Normalerweise 60x die Sekunde, kann aber auch weniger)
func _process(delta):
	pass

# Wird 60x die Sekunde aufgerufen (Wenn das Spiel langsam ist - 
func _physics_process(delta):
	pass
