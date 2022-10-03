extends Control

var display_name : String setget _set_display_name, _get_display_name
var text : String setget _set_text, _get_text

onready var dialogue_text = get_node("%DialogueText")
onready var character_name = get_node("%CharacterName")

onready var tween = get_node("Tween")
onready var blip_timers_node = get_node("BlipTimers")

onready var proceed_indicator = get_node("BoxPanel/ProceedIndicator")
onready var proceed_indicator_timer = get_node("BoxPanel/ProceedIndicator/Timer")

var _animation_duration_per_char = 0.014

var _play_blips = false

signal reading_finished

func _ready():
	for blip_timer in blip_timers_node.get_children():
		blip_timer.connect("timeout", self, "_on_blip_timer_timeout", [blip_timer])
	
	proceed_indicator_timer.connect("timeout", self, "_on_ProceedIndicator_switch")
	tween.connect("tween_all_completed", self, "_animation_finished")

func _set_text(new_val):
	dialogue_text.text = new_val
	_animate_dialogue_text()

func _on_blip_timer_timeout(node):
	if node.name.ends_with(display_name) and _play_blips:
		SoundController.play_effect(node.sound_file, node.pitch_scale)

func _get_text():
	return dialogue_text.text

func _set_display_name(new_val):
	character_name.text = new_val
	
	if blip_timers_node.has_node("Timer" + new_val):
		var blip_timer_node = blip_timers_node.get_node("Timer" + new_val)
		_animation_duration_per_char = blip_timer_node.animation_duration_per_char

func _get_display_name():
	return character_name.text

func _input(event):
	if event.is_action_pressed("option_select"):
		print("enter")
		_play_blips = false
		emit_signal("reading_finished")

func _on_ProceedIndicator_switch():
	proceed_indicator.visible = dialogue_text.percent_visible == 1.0 and not proceed_indicator.visible

func _animate_dialogue_text():
	tween.stop_all()
	tween.reset_all()
	tween.interpolate_property(dialogue_text, "percent_visible", 0.0, 1.0, len(self.text) *_animation_duration_per_char)
	_play_blips = true
	tween.start()

func _animation_finished():
	_play_blips = false

