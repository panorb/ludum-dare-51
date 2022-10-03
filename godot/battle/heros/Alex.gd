extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var health : int = 1000
var damage_melee : int = 100
var damage_ranged_combat : int = 80
var accuracy : int = 75
var critchance_melee : int = 50
var critchance_ranged_combat : int = 80
var critdamage_melee : int = 150
var critdamage_ranged_combat : int = 250

var MELEE = 0
var RANGED_COMBAT = 1

var attack_type : int = MELEE

onready var tween = get_node("Tween")

var original_pos = null

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	original_pos = position

func switch_attack_type(): 
	if attack_type == MELEE:
		attack_type = RANGED_COMBAT
		self.frame = 1
	elif attack_type == RANGED_COMBAT:
		attack_type = MELEE
		self.frame = 0
	
	SoundController.play_effect("after_image.wav")

func animate_heal():
	get_node("HealParticle").visible = true
	yield(get_tree().create_timer(0.05), "timeout")
	SoundController.play_effect("heal_particle.wav")
	yield(get_tree().create_timer(0.8), "timeout")
	get_node("HealParticle").visible = false

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
