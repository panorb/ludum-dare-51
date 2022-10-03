extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

signal go_to_start_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("Fade in")
	yield(animation_player, "animation_finished")
	animation_player.play("Fade Out")
	yield(animation_player, "animation_finished")
	emit_signal("go_to_start_screen")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
