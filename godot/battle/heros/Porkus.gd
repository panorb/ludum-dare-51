extends "StandardHero.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	skill = {Globals.skilltypes["Higher Damage"] : 50, "Cooldown": 2}
	pass
	# ._ready()


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
