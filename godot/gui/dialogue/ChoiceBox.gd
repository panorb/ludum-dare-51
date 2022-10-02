extends Control

var choices setget _set_choices
var selected_index := 0
var _choice_amount := 3

onready var _choices_node = get_node("%Choices")
signal choice_selected(choice_index)

func _set_choices(new_val):
	selected_index = 0
	_choice_amount = len(new_val)
	
	for i in range(len(new_val)):
		var choice_node = _choices_node.get_node("Choice" + str(i + 1))
		choice_node.text = new_val[i]
	
	_update_choice_display()

func _ready():
	_update_choice_display()

func _input(event):
	if event.is_action_pressed("ui_up"):
		selected_index -= 1
		if selected_index < 0:
			selected_index = _choice_amount + selected_index
		_update_choice_display()
	elif event.is_action_pressed("ui_down"):
		selected_index += 1
		if selected_index >= _choice_amount:
			selected_index = _choice_amount - selected_index
		_update_choice_display()
	
	if event.is_action_pressed("ui_accept"):
		emit_signal("choice_selected")
		print("choice_selected " + str(selected_index))

func _update_choice_display():
	for i in range(3):
		var choice = _choices_node.get_node("Choice" + str(i + 1))
		
		if i == selected_index:
			choice.material["shader_param/line_thickness"] = 2.0
			choice.material["shader_param/line_color"] = Color("#ff0040")
		else:
			choice.material["shader_param/line_thickness"] = 1.0
			choice.material["shader_param/line_color"] = Color("#b4b4b4")
