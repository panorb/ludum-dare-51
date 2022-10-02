extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var alex = get_node("Alex")
onready var david = get_node("David")
onready var gandalf = get_node("Gandalf")
onready var gimbli = get_node("Gimbli")

var number_of_supporter : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_supporter_count()
	init_positions()
	
func calculate_supporter_count():
	if Globals.david_alive:
		number_of_supporter += 1
	if Globals.gandalf_alive:
		number_of_supporter += 1
	if Globals.gimbli_alive:
		number_of_supporter += 1

func init_positions():
	var position_left_up : Vector2 = Vector2(24,48 + (3 - number_of_supporter) * 24)
	var alex_position_left_up : Vector2 = Vector2(24,48)
	alex.position = alex_position_left_up + (2 * Vector2(0,48)) + Vector2(48,0)
	var count : int = 1
	if Globals.david_alive:
		david.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.gandalf_alive:
		gandalf.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.gimbli_alive:
		gimbli.position = position_left_up + (count * Vector2(0,48))
		count += 1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
