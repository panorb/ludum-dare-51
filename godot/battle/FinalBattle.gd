extends Node

var list_skills_activate = {}

onready var alex = get_node("PositioningHeros/Alex")
onready var david = get_node("PositioningHeros/David")
onready var gandalf = get_node("PositioningHeros/Gandalf")
onready var porkus = get_node("PositioningHeros/Porkus")
onready var time_stealer = get_node("PositioningBoss/Time Stealer")

signal david_on_cooldown

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("end_round"):
		on_end_round()

func calucuate_damage():
	alex.health -= time_stealer.damage
	
	new_round()

func new_round():
	if !david.on_cooldown:
		list_skills_activate.merge(david.skill)
		david.on_cooldown = true
	else:
		david.cooldown_length -= 1
	if !gandalf.on_cooldown:
		list_skills_activate.merge(gandalf.skill)
		gandalf.on_cooldown = true
	else:
		gandalf.cooldown_length -= 1
	if !porkus.on_cooldown:
		list_skills_activate.merge(porkus.skill)
		porkus.on_cooldown = true
	else:
		porkus.cooldown_length -= 1

func on_end_round():
	print("End Round")
	calucuate_damage()
