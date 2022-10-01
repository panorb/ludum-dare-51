extends Control

var display_name : String setget _set_display_name, _get_display_name
var text : String setget _set_text, _get_text

onready var dialogue_text = get_node("%DialogueText")
onready var character_name = get_node("%CharacterName")

onready var tween = get_node("Tween")

onready var proceed_indicator = get_node("BoxPanel/ProceedIndicator")
onready var proceed_indicator_timer = get_node("BoxPanel/ProceedIndicator/Timer")


func _set_text(new_val):
	dialogue_text.text = new_val
	_animate_dialogue_text()

func _get_text():
	return dialogue_text.text

func _set_display_name(new_val):
	character_name.text = new_val

func _get_display_name():
	return character_name.text

func _ready():
	yield(get_tree().create_timer(1.0), "timeout")
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
