extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health : int = 1000
var damage : int = 100
var critchance : int = 75
var critdamage : int = 150

onready var tween : Tween = get_node("Tween")

var original_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	original_pos = position

func animate_damage():
	tween.reset_all()
	tween.remove_all()
	
	tween.interpolate_property(self, "self_modulate", self_modulate, Color.red, 0.2)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "self_modulate", Color.red, Color.white, 0.15)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "self_modulate", Color.white, Color.red, 0.2)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "self_modulate", Color.red, Color.white, 0.15)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "self_modulate", Color.white, Color.red, 0.2)
	tween.start()
	yield(tween, "tween_all_completed")
	
	tween.interpolate_property(self, "self_modulate", Color.red, Color.white, 0.15)
	tween.start()
	yield(tween, "tween_all_completed")
