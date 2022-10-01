extends Node

onready var scenes = get_node("Scenes")
var final_battle : Resource = preload("res://battle/FinalBattle.tscn")
var i := 0

func _ready():
	print("David exhausted? " + str(Globals.david_exhausted))
	add_child(final_battle.instance())
	# i = "hallo"

# Wird jedes Idleframe aufgerufen (Normalerweise 60x die Sekunde, kann aber auch weniger)
func _process(delta):
	pass

# Wird 60x die Sekunde aufgerufen (Wenn das Spiel langsam ist - 
func _physics_process(delta):
	pass

func _input(event):
	# if event.is_action_pressed()
	pass
