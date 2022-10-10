extends Control

var text : String setget _set_text, _get_text

onready var dialogue_text = get_node("%DialogueText")

onready var tween = get_node("Tween")

onready var proceed_indicator = get_node("BoxPanel/ProceedIndicator")
onready var proceed_indicator_timer = get_node("BoxPanel/ProceedIndicator/Timer")

onready var blip_timer = get_node("BlipTimer")
var _play_blips = false
var skipable = false

onready var _animation_duration_per_char = blip_timer.animation_duration_per_char

signal reading_finished

func _set_text(new_val):
	dialogue_text.bbcode_text = "[center]" + new_val + "[/center]"
	_animate_dialogue_text()

func _get_text():
	return dialogue_text.text

func _input(event):
	if event.is_action_pressed("option_select"):
		_play_blips = false
		if skipable:
			skipable = false
			emit_signal("reading_finished")
		else:
			tween.remove_all()
			tween.interpolate_property(dialogue_text, "percent_visible", 1.0, 1.0, len(self.text) *_animation_duration_per_char)
			tween.start()
			skipable = true

func _ready():
	proceed_indicator_timer.connect("timeout", self, "_on_ProceedIndicator_switch")
	blip_timer.connect("timeout", self, "_on_BlipTimer_timeout")
	tween.connect("tween_all_completed", self, "_animation_finished")

func _on_BlipTimer_timeout():
	if _play_blips:
		SoundController.play_effect(blip_timer.sound_file, blip_timer.pitch_scale)

func _on_ProceedIndicator_switch():
	proceed_indicator.visible = dialogue_text.percent_visible == 1.0 and not proceed_indicator.visible

func _animation_finished():
	_play_blips = false

func _animate_dialogue_text():
	_play_blips = true
	
	tween.remove_all()
	tween.interpolate_property(dialogue_text, "percent_visible", 0.0, 1.0, len(self.text) * _animation_duration_per_char)
	tween.start()
