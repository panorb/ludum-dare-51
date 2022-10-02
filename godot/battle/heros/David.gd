extends "StandardHero.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	cooldown_length = 3
	skill = {Globals.skilltypes["Higher Accuracy"] : 20}
	pass
	# ._ready()
	
func set_on_cooldown(value : bool):
	on_cooldown = value
	cooldown_length = 3
	
func get_on_cooldown():
	return on_cooldown
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
