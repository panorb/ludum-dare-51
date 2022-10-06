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
var on_cooldown : bool = false
var cooldown_length : int setget set_cooldown_length, get_cooldown_length

onready var after_image = get_node("AfterImage")
onready var animation_player = get_node("AnimationPlayer")

onready var tween = get_node("Tween")
onready var attack_type_indicator = get_node("AttackTypeIndicator")
onready var cooldown_indicator = get_node("CooldownIndicator")

# Called when the node enters the scene tree for the first time.
func _ready():
	after_image.frames = self.frames
	after_image.self_modulate = Color(1, 1, 1, 0)
	
	yield(get_tree(), "idle_frame")
	attack_type_indicator.visible = true
	attack_type_indicator.frame = skill_boost_type

func switch_sprite(type : int): 
	if skill_boost_type == type:
		if show_sprite == SKILL_INACTIVE:
			show_sprite = SKILL_ACTIVE
			self.frame = 1
			_animate_after_image()
		elif show_sprite == SKILL_ACTIVE:
			show_sprite = SKILL_INACTIVE
			self.frame = 0
	elif skill_boost_type == LIFESTEAL:
		if show_sprite == SKILL_INACTIVE:
			show_sprite = SKILL_ACTIVE
			self.frame = 1
			_animate_after_image()
		elif show_sprite == SKILL_ACTIVE:
			show_sprite = SKILL_INACTIVE
			self.frame = 0
	else:
		SoundController.play_effect("error.wav")
		flash_indicators()

func flash_indicators() -> void:
	tween.remove_all()
	attack_type_indicator.modulate = Color(1, 1, 1, 1)
	cooldown_indicator.modulate = Color(1, 1, 1, 1)
	tween.interpolate_property(attack_type_indicator, "modulate", Color(1, 1, 1, 1), Color("#ea323c"), 0.14, Tween.TRANS_EXPO)
	tween.interpolate_property(cooldown_indicator, "modulate", Color(1, 1, 1, 1), Color("#ea323c"), 0.14, Tween.TRANS_EXPO)
	tween.start()
	
	yield(tween, "tween_all_completed")
	attack_type_indicator.modulate = Color("#ea323c")
	cooldown_indicator.modulate = Color("#ea323c")
	tween.interpolate_property(attack_type_indicator, "modulate", Color("#ea323c"), Color(1, 1, 1, 1), 0.8, Tween.TRANS_EXPO)
	tween.interpolate_property(cooldown_indicator, "modulate", Color("#ea323c"), Color(1, 1, 1, 1), 0.8, Tween.TRANS_EXPO)
	tween.start()

func is_usable(type : int) -> bool:
	if on_cooldown:
		cooldown_indicator.visible = true
		return false
	else:
		cooldown_indicator.visible = false
	
	if skill_boost_type == type:
		return true
	elif skill_boost_type == LIFESTEAL:
		return true
	else:
		return false

func _animate_after_image():
	animation_player.play("after_image")
	SoundController.play_effect("after_image.wav")

func reset_sprite():
	show_sprite = SKILL_INACTIVE
	self.frame = 0

func set_show_sprite(value : int):
	show_sprite = value
	
func get_show_sprite():
	return show_sprite
	
func set_cooldown_length(value : int):
	cooldown_length = value
	if cooldown_length <= 0:
		on_cooldown = false
	
func get_cooldown_length():
	return cooldown_length
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
