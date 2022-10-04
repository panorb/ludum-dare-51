extends Node

var list_skills_activate = {}

onready var alex = get_node("PositioningHeros/Alex")
onready var david = get_node("PositioningHeros/David")
onready var gandalf = get_node("PositioningHeros/Gandalf")
onready var porkus = get_node("PositioningHeros/Porkus")
onready var lilith = get_node("PositioningHeros/Lilith")
onready var aelrin = get_node("PositioningHeros/Aelrin")
onready var dracula = get_node("PositioningHeros/Dracula")
onready var time_stealer = get_node("PositioningBoss/TimeStealer")

onready var positioning_heros = get_node("PositioningHeros")
onready var positioning_boss = get_node("PositioningBoss")

onready var tween = get_node("Tween")

onready var list_supporters = []
var end_off_game : bool = false

signal end_of_battle(win)

func _ready():
	if Globals.flags["DavidPresent"]:
		list_supporters.append(david)
	if Globals.flags["GandalfPresent"]:
		list_supporters.append(gandalf)
	if Globals.flags["PorkusPresent"]:
		list_supporters.append(porkus)	
	if Globals.flags["LilithPresent"]:
		list_supporters.append(lilith)
	if Globals.flags["AelrinPresent"]:
		list_supporters.append(aelrin)
	if Globals.flags["DrakulaPresent"]:
		list_supporters.append(dracula)
	pass

var in_animation = false

func _input(event):
	if not end_off_game and not in_animation:
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
	in_animation = true
	
	print(list_skills_activate)
	
	tween.remove_all()
	tween.interpolate_property(time_stealer, "position", time_stealer.original_pos, Vector2(time_stealer.original_pos.x - 50, time_stealer.original_pos.y), 0.5, Tween.TRANS_EXPO)
	tween.start()
	yield(tween, "tween_all_completed")
	
	damage_time_stealer()
	SoundController.play_effect("man_hurt.wav")
	alex.animate_damage()
	
	tween.interpolate_property(time_stealer, "position", time_stealer.position, time_stealer.original_pos, 0.8, Tween.TRANS_EXPO)
	tween.start()
	yield(tween, "tween_all_completed")
	
	if !end_off_game:
		tween.remove_all()
		tween.interpolate_property(alex, "position", alex.original_pos, Vector2(alex.original_pos.x + 50, alex.original_pos.y), 0.7, Tween.TRANS_EXPO)
		tween.start()
		yield(tween, "tween_all_completed")
		
		damage_alex()
		SoundController.play_effect("meat_impact.wav")
		time_stealer.animate_damage()
		
		tween.interpolate_property(alex, "position", alex.position, alex.original_pos, 0.8, Tween.TRANS_EXPO)
		tween.start()
		yield(tween, "tween_all_completed")
		
		list_skills_activate = {}
		
		in_animation = false
		print("Health Alex: ", alex.health," Health Time Stealer: ", time_stealer.health)
	
	positioning_heros.reset_all_sprites()


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
		emit_signal("end_of_battle", true)
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
		emit_signal("end_of_battle", false)
		end_off_game = true
	
	positioning_heros.change_value_health_bar(alex.health)

func end_round():
	in_animation = true
	for supporter in list_supporters:
		if !supporter.on_cooldown && (supporter.show_sprite == supporter.SKILL_ACTIVE):
			list_skills_activate.merge(supporter.skill)
			supporter.on_cooldown = true
		else:
			supporter.cooldown_length -= 1
	calucuate_damage()

