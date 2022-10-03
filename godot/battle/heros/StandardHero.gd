extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SKILL_INACTIVE = 0
var SKILL_ACTIVE = 1

var MELEE = 0
var RANGED_COMBAT = 1
var LIFESTEAL = 2

var skill_boost_type : int
var show_sprite : int = SKILL_INACTIVE setget set_show_sprite, get_show_sprite
var skill = {}
var on_cooldown : bool = false setget set_on_cooldown, get_on_cooldown
var cooldown_length : int setget set_cooldown_length, get_cooldown_length
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch_sprite(type : int): 
	if skill_boost_type == type:
		print("Here")
		if show_sprite == SKILL_INACTIVE:
			show_sprite = SKILL_ACTIVE
			self.frame = 1
		elif show_sprite == SKILL_ACTIVE:
			show_sprite = SKILL_INACTIVE
			self.frame = 0
	elif skill_boost_type == LIFESTEAL:
		if show_sprite == SKILL_INACTIVE:
			show_sprite = SKILL_ACTIVE
			self.frame = 1
		elif show_sprite == SKILL_ACTIVE:
			show_sprite = SKILL_INACTIVE
			self.frame = 0
	else:
		print("Skill not for current Attackmode.")

func reset_sprite():
	show_sprite = SKILL_INACTIVE
	self.frame = 0

func set_show_sprite(value : int):
	show_sprite = value
	
func get_show_sprite():
	return show_sprite

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
