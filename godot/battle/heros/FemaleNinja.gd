extends "StandardHero.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	skill_boost_type = RANGED_COMBAT
	skill = {Globals.SKILL_HIGHER_ACCURACY : 25}
	cooldown_length = 3
	pass
	# ._ready()

func set_on_cooldown(value : bool):
	on_cooldown = value
	if on_cooldown:
		cooldown_length = 3
	
func get_on_cooldown():
	return on_cooldown

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
