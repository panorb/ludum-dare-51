extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var alex = get_node("Alex")
onready var david = get_node("David")
onready var gandalf = get_node("Gandalf")
onready var porkus = get_node("Porkus")
onready var female_ninja = get_node("FemaleNinja")
onready var male_ninja = get_node("MaleNinja")
onready var dracula = get_node("Dracula")

onready var health_bar_alex = get_node("Control/HealthBarAlex")

onready var frame = get_node("Frame")
var frame_left : bool = true
var frame_level : int = 1

onready var list_supporters = []
var number_of_supporter : int = 0

var position_left_up : Vector2
var alex_position_left_up : Vector2 = Vector2(24,48)

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar_alex.max_value = alex.health
	health_bar_alex.step = 1
	health_bar_alex.value = alex.health
	calculate_supporter_count()
	init_positions()
	reset_all_sprites()
	
func calculate_supporter_count():
	if Globals.flags["DavidPresent"]:
		list_supporters.append(david)
		number_of_supporter += 1
	if Globals.flags["GandalfPresent"]:
		list_supporters.append(gandalf)
		number_of_supporter += 1
	if Globals.flags["PorkusPresent"]:
		list_supporters.append(porkus)
		number_of_supporter += 1
	if Globals.flags["FemaleNinjaPresent"]:
		list_supporters.append(female_ninja)
		number_of_supporter += 1
	if Globals.flags["MaleNinjaPresent"]:
		list_supporters.append(male_ninja)
		number_of_supporter += 1
	if Globals.flags["DraculaPresent"]:
		list_supporters.append(dracula)
		number_of_supporter += 1
	position_left_up = Vector2(24,48 + (3 - number_of_supporter) * 24)

func init_positions():
	alex.position = alex_position_left_up + (2 * Vector2(0,48)) + Vector2(68,0)
	health_bar_alex.rect_position = alex.position + Vector2(0, -48) - health_bar_alex.rect_pivot_offset
	frame.position = position_left_up + (frame_level * Vector2(0,48))
	var count : int = 1
	if Globals.flags["DavidPresent"]:
		david.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.flags["GandalfPresent"]:
		gandalf.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.flags["PorkusPresent"]:
		porkus.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.flags["FemaleNinjaPresent"]:
		female_ninja.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.flags["MaleNinjaPresent"]:
		male_ninja.position = position_left_up + (count * Vector2(0,48))
		count += 1
	if Globals.flags["DraculaPresent"]:
		dracula.position = position_left_up + (count * Vector2(0,48))
		count += 1

func move_frame_up():
	if frame_level == 1 || !frame_left:
		return
	else:
		frame_level -= 1
		frame.position = position_left_up + (frame_level * Vector2(0,48))
		
func move_frame_down():
	if frame_level == number_of_supporter || !frame_left:
		return
	else:
		frame_level += 1
		frame.position = position_left_up + (frame_level * Vector2(0,48))
		
func move_frame_right():
	if !frame_left:
		return
	else:
		frame_left = false
		frame.position = alex.position
		
func move_frame_left():
	if frame_left:
		return
	else:
		frame_left = true
		frame.position = position_left_up + (frame_level * Vector2(0,48))
		
func change_value_health_bar(value : int):
	if value < 0:
		value = 0
	health_bar_alex.value = value
	if health_bar_alex.value <= (health_bar_alex.max_value / 2):
		health_bar_alex.get("custom_styles/fg").set_bg_color(Color(1.0, 0.853, 0.0, 1.0))
	if health_bar_alex.value <= (health_bar_alex.max_value / 10):
		health_bar_alex.get("custom_styles/fg").set_bg_color(Color(1.0, 0.0, 0.0, 1.0))
		
func switch_sprite():
	if !frame_left:
		alex.switch_attack_type()
		reset_all_sprites()
		#Alex wechsel der Waffen implementieren
	else:
		if list_supporters[frame_level - 1].on_cooldown:
			print("Skill on Cooldown.")
		else:
			list_supporters[frame_level-1].switch_sprite(alex.attack_type)
		
func reset_all_sprites():
	for supporter in list_supporters:
		if supporter.show_sprite == supporter.SKILL_ACTIVE:
			supporter.reset_sprite()
		
		
		if supporter.is_usable(alex.attack_type):
			supporter.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
		else:
			supporter.self_modulate = Color(0.6, 0.6, 0.6, 1.0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
