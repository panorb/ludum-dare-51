extends Node

var list_skills_activate = {}

var paused : bool = false

onready var pause_menu : PackedScene = preload("res://gui/pause_screen/PauseScreen.tscn")
var pause_scene : Node
onready var resume_button : Button 
onready var back_to_title_button : Button

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

onready var dialogue_manager = get_node("DialogueManager")

onready var tween = get_node("Tween")

onready var skip_button : Button = get_node("SkipButton")

onready var list_supporters = []
var end_off_game : bool = false
var in_tutorial = true
var enter_delay = false
var first_helper : String = ""

var in_animation = false

signal end_of_battle(win)

func _ready():
	if Globals.flags["DavidPresent"]:
		list_supporters.append(david)
		first_helper = "David"
		Globals.flags["hasSupport"] = true
	if Globals.flags["GandalfPresent"]:
		list_supporters.append(gandalf)
		Globals.flags["hasSupport"] = true
		if first_helper.empty():
			first_helper = "Gandalf"
	if Globals.flags["PorkusPresent"]:
		list_supporters.append(porkus)
		Globals.flags["hasSupport"] = true
		if first_helper.empty():
			first_helper = "Porkus"
	if Globals.flags["LilithPresent"]:
		list_supporters.append(lilith)
		Globals.flags["hasSupport"] = true
		if first_helper.empty():
			first_helper = "Lilith"
	if Globals.flags["AelrinPresent"]:
		list_supporters.append(aelrin)
		Globals.flags["hasSupport"] = true
		if first_helper.empty():
			first_helper = "Aelrin"
	if Globals.flags["DrakulaPresent"]:
		list_supporters.append(dracula)
		Globals.flags["hasSupport"] = true
		if first_helper.empty():
			first_helper = "Drakula"
	
	skip_button.connect("pressed", self, "_on_SkipButton_pressed")
	dialogue_manager.start_dialogue("res://content/new_dialogue/BattleTutorial.json")
	dialogue_manager.connect("action_intro", self, "action_intro_help")

func action_intro_help(value : int):
	if value == 1:
		dialogue_manager.dialogue_box.isReady = false
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		if first_helper == "David" or first_helper == "Gandalf" or first_helper == "Lilith":
			yield(get_tree().create_timer(1.0), "timeout")
			positioning_heros.switch_sprite()
		dialogue_manager.dialogue_box.isReady = true
	elif value == 2:
		positioning_heros.move_frame_left()
		positioning_heros.switch_sprite()
	elif value == 3:
		positioning_heros.move_frame_right()
		if first_helper == "David" or first_helper == "Gandalf" or first_helper == "Lilith":
			positioning_heros.switch_sprite()
		positioning_heros.reset_all_sprites()
	elif value == 4:
		in_tutorial = false
		skip_button.visible = false
		dialogue_manager.visible = false
		dialogue_manager.dialogue_box.isReady = false
	elif value == 5:
		dialogue_manager.dialogue_box.isReady = false
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		yield(get_tree().create_timer(1.0), "timeout")
		positioning_heros.switch_sprite()
		dialogue_manager.dialogue_box.isReady = true

func _input(event):
	if !paused && event.is_action_pressed("pause_menu"):
		pause_scene = pause_menu.instance()
		add_child(pause_scene)
		paused = true
		resume_button = get_node("PauseScreen/VBoxContainer/ResumeButton")
		back_to_title_button = get_node("PauseScreen/VBoxContainer/BackToTitleButton")
		resume_button.connect("pressed", self, "_on_ResumeButton_pressed")
		back_to_title_button.connect("pressed", self, "_on_BackToTitleButton_pressed")
	if in_tutorial:
		return
	elif !enter_delay:
		enter_delay = true
	elif not end_off_game and not in_animation:
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
		if event.is_action_pressed("battle_toggle_skill"):
			positioning_heros.switch_sprite()
			
			
func _on_ResumeButton_pressed():
	pause_scene.queue_free()
	paused = false
	
func _on_BackToTitleButton_pressed():
	pause_scene.queue_free()
	paused = false
	SoundController.stop_all()
	emit_signal("back_to_title")
	
func _on_SkipButton_pressed():
	skip_button.visible = false
	dialogue_manager.visible = false
	in_tutorial = false
	dialogue_manager.dialogue_box.isReady = false

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

