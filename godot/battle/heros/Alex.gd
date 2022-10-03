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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func switch_attack_type(): 
	if attack_type == MELEE:
		attack_type = RANGED_COMBAT
		self.frame = 1
	elif attack_type == RANGED_COMBAT:
		attack_type = MELEE
		self.frame = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
