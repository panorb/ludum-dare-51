extends Node

var list_skills_activate = {}

onready var alex = get_node("PositioningHeros/Alex")
onready var david = get_node("PositioningHeros/David")
onready var gandalf = get_node("PositioningHeros/Gandalf")
onready var porkus = get_node("PositioningHeros/Porkus")
onready var female_ninja = get_node("PositioningHeros/FemaleNinja")
onready var male_ninja = get_node("PositioningHeros/MaleNinja")
onready var dracula = get_node("PositioningHeros/Dracula")
onready var time_stealer = get_node("PositioningBoss/Time Stealer")

onready var positioning_heros = get_node("PositioningHeros")
onready var positioning_boss = get_node("PositioningBoss")

onready var list_supporters = []
var end_off_game : bool = false
func _ready():
	if Globals.flags["DavidPresent"]:
		list_supporters.append(david)
	if Globals.flags["GandalfPresent"]:
		list_supporters.append(gandalf)
	if Globals.flags["PorkusPresent"]:
		list_supporters.append(porkus)	
	if Globals.flags["FemaleNinjaPresent"]:
		list_supporters.append(female_ninja)
	if Globals.flags["MaleNinjaPresent"]:
		list_supporters.append(male_ninja)
	if Globals.flags["DraculaPresent"]:
		list_supporters.append(dracula)
	pass

func _input(event):
	if !end_off_game:
		if event.is_action_pressed("end_round"):
			end_round()
		if event.is_action_pressed("battle_move_frame_up"):
			positioning_heros.move_frame_up()
		if event.is_action_pressed("battle_move_frame_down"):
			positioning_heros.move_frame_down()
		if event.is_action_pressed("battle_move_frame_left"):
			positioning_heros.move_frame_left()
		if event.is_action_pressed("battle_move_frame_right"):
			positioning_heros.move_frame_right()
		if event.is_action_pressed("battle_toogle_skill"):
			positioning_heros.switch_sprite()
			
func calucuate_damage():
	print(list_skills_activate)
	damage_time_stealer()
	if !end_off_game:
		damage_alex()
		list_skills_activate = {}
		print("Health Alex: ", alex.health," Health Time Stealer: ", time_stealer.health)

func damage_alex():
	var damage = 0
	var critchance = 0
	var critdamage = 0
	var accurancy = alex.accuracy
	var attack_type = alex.attack_type
	
	if attack_type == alex.MELEE:
		damage = alex.damage_melee
		critchance = alex.critchance_melee
		critdamage = alex.critdamage_melee
		
		if list_skills_activate.has(Globals.SKILL_HIGHER_DAMAGE_MELEE):
			damage += list_skills_activate[Globals.SKILL_HIGHER_DAMAGE_MELEE]
		if list_skills_activate.has(Globals.SKILL_HIGHER_CRIT_CHANCE_MELEE):
			critchance += list_skills_activate[Globals.SKILL_HIGHER_CRIT_CHANCE_MELEE]
			
		var random_value : float = 0.0
		randomize()
		random_value = randf() * 100
		
		if random_value < critchance:
			time_stealer.health -= damage * critdamage / 100
		else:
			time_stealer.health -= damage
	else:
		damage = alex.damage_ranged_combat
		critchance = alex.critchance_ranged_combat
		critdamage = alex.critdamage_ranged_combat
		
		if list_skills_activate.has(Globals.SKILL_HIGHER_ACCURACY):
			accurancy += list_skills_activate[Globals.SKILL_HIGHER_ACCURACY]
		if list_skills_activate.has(Globals.SKILL_HIGHER_DAMAGE_RANGED_COMBAT):
			damage += list_skills_activate[Globals.SKILL_HIGHER_DAMAGE_RANGED_COMBAT]
		if list_skills_activate.has(Globals.SKILL_HIGHER_CRIT_CHANCE_RANGED_COMBAT):
			critchance += list_skills_activate[Globals.SKILL_HIGHER_CRIT_CHANCE_RANGED_COMBAT]
		
		var random_value : float = 0.0
		randomize()
		random_value = randf() * 100
		if random_value < accurancy:
			random_value = randf() * 100
			if random_value < critchance:
				time_stealer.health -= damage * critdamage / 100
			else:
				time_stealer.health -= damage
	
	if list_skills_activate.has(Globals.SKILL_LIFESTEAL):
		alex.health += damage / 5
		positioning_heros.change_value_health_bar(alex.health)
		
	if time_stealer.health <= 0:
		print("You Win.")
		end_off_game = true
	positioning_boss.change_value_health_bar(time_stealer.health)
	print("Damage: ", damage, " CritChance: ", critchance, " Accurancy: ", accurancy)

func damage_time_stealer():
	var random_value : float = 0.0
	randomize()
	random_value = randf() * 100
	if random_value < time_stealer.critchance:
		alex.health -= time_stealer.damage * time_stealer.critdamage / 100
	else:
		alex.health -= time_stealer.damage
	if alex.health <= 0:
		print("You Lose.")
		end_off_game = true
	positioning_heros.change_value_health_bar(alex.health)

func end_round():
	for supporter in list_supporters:
		if !supporter.on_cooldown && (supporter.show_sprite == supporter.SKILL_ACTIVE):
			list_skills_activate.merge(supporter.skill)
			supporter.on_cooldown = true
		else:
			supporter.cooldown_length -= 1
	positioning_heros.reset_all_sprites()
	calucuate_damage()
