extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var show_spite : int = 0
var skill = {}
var on_cooldown : bool = false setget set_on_cooldown, get_on_cooldown
var cooldown_length : int setget set_cooldown_length, get_cooldown_length
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch_spite(value : int):
	show_spite = value
	if show_spite == 0:
		self.texture.set_region(Rect2(0, 0, 48, 48))
	elif show_spite == 1:
		self.texture.set_region(Rect2(48, 0, 48, 48))

func set_on_cooldown(value : bool):
	pass
	
func get_on_cooldown():
	pass
	
func set_cooldown_length(value : int):
	cooldown_length = value
	if cooldown_length <= 0:
		on_cooldown = false
	
func get_cooldown_length():
	return cooldown_length
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
