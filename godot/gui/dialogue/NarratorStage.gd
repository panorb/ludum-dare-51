extends Control

var text : String setget _set_text, _get_text

onready var dialogue_text = get_node("%DialogueText")

onready var tween = get_node("Tween")

onready var proceed_indicator = get_node("BoxPanel/ProceedIndicator")
onready var proceed_indicator_timer = get_node("BoxPanel/ProceedIndicator/Timer")

signal reading_finished

func _set_text(new_val):
	dialogue_text.bbcode_text = "[center]" + new_val + "[/center]"
	_animate_dialogue_text()

func _get_text():
	return dialogue_text.text

func _input(event):
	if event.is_action_pressed("option_select"):
		print("enter")
		emit_signal("reading_finished")


func _ready():
	proceed_indicator_timer.connect("timeout", self, "_on_ProceedIndicator_switch")

func _on_ProceedIndicator_switch():
	proceed_indicator.visible = dialogue_text.percent_visible == 1.0 and not proceed_indicator.visible
	
func _on_animation_finished(animation_name):
	print(animation_name)

func _animate_dialogue_text():
	tween.stop_all()
	tween.reset_all()
	tween.interpolate_property(dialogue_text, "percent_visible", 0.0, 1.0, len(self.text) * 0.01)
	tween.start()
