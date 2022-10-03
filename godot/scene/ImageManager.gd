extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var texture_rect = get_node("TextureRect")
onready var animation_player = get_node("AnimationPlayer")
var directory : String = "res://background/"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_image(image_name : String):
	texture_rect.texture = load(directory + image_name)
	#animate_zoom_into_image()

func animate_zoom_into_image():
	#animation_player.advance(10)
	animation_player.play("walk around")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
