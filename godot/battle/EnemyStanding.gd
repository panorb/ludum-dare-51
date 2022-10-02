extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var time_stealer = get_node("Time Stealer")

var position_left_up : Vector2 = Vector2(24,48)

# Called when the node enters the scene tree for the first time.
func _ready():
	init_positions()

func init_positions():
	time_stealer.position = position_left_up + (2 * Vector2(0,48)) + Vector2(350,24)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
