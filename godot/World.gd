extends Node

onready var scenes = get_node("Scenes")
var final_battle : PackedScene = preload("res://battle/FinalBattle.tscn")
var start_screen : PackedScene = preload("res://gui/start_screen/StartScreen.tscn")
var pause_screen : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
var current_scene : Node

func _ready():
	print("David exhausted? " + str(Globals.david_exhausted))
	
	change_scene(start_screen)
	current_scene.connect("back_to_title_button_pressed", self, "change_scene", [start_screen])
	#start_screen_instance.connect("start_button_pressed", self, "change_scene", game_scene)
	#add_child(pause_screen.instance())
	# add_child(final_battle.instance())
	# i = "hallo"

func change_scene(scene : PackedScene):
	if current_scene:
		current_scene.queue_free()
	current_scene = scene.instance()
	print("Here")
	add_child(current_scene)

# Wird jedes Idleframe aufgerufen (Normalerweise 60x die Sekunde, kann aber auch weniger)
func _process(delta):
	pass

# Wird 60x die Sekunde aufgerufen (Wenn das Spiel langsam ist - 
func _physics_process(delta):
	pass

func _input(event):
	# if event.is_action_pressed()
	pass
