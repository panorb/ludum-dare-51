extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json_data = {}
var current_node 
var local = {} # Stores local variables from the editor
var box_style : String = ""

var dialogue_box_scene = preload("res://gui/dialogue/DialogueBox.tscn")
var choice_box_scene = preload("res://gui/dialogue/ChoiceBox.tscn")
var narrator_stage_scene = preload("res://gui/dialogue/NarratorStage.tscn")

onready var dialogue_box : Control = get_node("DialogueBox")
onready var choice_box : Control = get_node("ChoiceBox")
onready var narrator_stage : Control = get_node("NarratorStage")

signal dialogue_signal(command)

# Called when the node enters the scene tree for the first time.
func _ready():
	start_dialogue("res://content/dialogue/Chapter2P1.json")
	handle_current_node()
	pass # Replace with function body.

func change_box_style(new_style):
	if box_style == new_style:
		return
	
	box_style = new_style
	
	if dialogue_box and dialogue_box.is_inside_tree():
		remove_child(dialogue_box)
		dialogue_box = null
	if choice_box and choice_box.is_inside_tree():
		remove_child(choice_box)
		choice_box = null
	if narrator_stage and narrator_stage.is_inside_tree():
		remove_child(narrator_stage)
		narrator_stage = null
	
	match box_style:
		"Dialogue":
			dialogue_box = dialogue_box_scene.instance()
			add_child(dialogue_box)
			dialogue_box.connect("reading_finished", self, "on_reading_finished")
		"Choice":
			choice_box = choice_box_scene.instance()
			add_child(choice_box)
			choice_box.connect("choice_selected", self, "on_choice_selected")
		"Stage":
			narrator_stage = narrator_stage_scene.instance()
			add_child(narrator_stage)
			narrator_stage.connect("reading_finished", self, "on_reading_finished")
			

func load_data(json_path):
	var file = File.new()
	file.open(json_path, File.READ)
	json_data = parse_json(file.get_as_text())
	file.close()
	
	# Copy variables
	for variable in json_data[0]["variables"]:
		local[variable] = json_data[0]["variables"][variable]["value"]
	
	# Overwritten known flags with their real value
	for flag in Globals.flags:
		local[flag] = Globals.flags[flag]
	
func get_dialogue_node_by_id(id):
	for node in json_data[0]["nodes"]:
		if node["node_name"] == id:
			return node
			
func find_start():
	for node in json_data[0]["nodes"]:
		if node["node_type"] == "start":
			return node

func set_local_var():
	var var_name = current_node["var_name"]
	
	if current_node["operation_type"] == "ADD":
		local[var_name]+= current_node["value"]
	if current_node["operation_type"] == "SUBSTRACT":
		local[var_name] -= current_node["value"]
	if current_node["operation_type"] == "SET":
		local[var_name] = current_node["value"]
	
	auto_next()
	handle_current_node()

func get_var(var_name):
	return local[var_name]

func start_dialogue(json_path):
	load_data(json_path)
	current_node = find_start()
	auto_next()
	
func on_choice_selected(choice_index):
	current_node = get_dialogue_node_by_id(current_node["choices"][choice_index]["next"])
	handle_current_node()
	
func on_reading_finished():
	auto_next()
	handle_current_node()

func show_message():
	if current_node["character"][0] == "Player":
		change_box_style("Choice")
		
		choice_box.question = current_node["text"]["ENG"]
		var tmp = []
		for i in range(len(current_node["choices"])):
			if not current_node["choices"][i]["is_condition"] or \
			 evaluate_value(current_node["choices"][i]["condition"]):
				tmp.append(current_node["choices"][i]["text"]["ENG"])
		choice_box.choices = tmp
	elif current_node["character"][0] == "Narrator":
		change_box_style("Stage")
		
		narrator_stage.text = current_node["text"]["ENG"]
	else:
		change_box_style("Dialogue")

		dialogue_box.display_name = current_node["character"][0]		
		dialogue_box.text = current_node["text"]["ENG"]

func auto_next():
	if current_node and current_node.has("next"):
		current_node = get_dialogue_node_by_id(current_node["next"])
	else:
		current_node = null

func handle_current_node():
	if not current_node:
		narrator_stage.text = "Next Chapter"#assert(false, "Implement next chapter here")
	elif current_node["node_type"] == "condition_branch":
		condition_branch()
	elif current_node["node_type"] == "show_message":
		show_message()
	elif current_node["node_type"] == "set_local_variable":
		set_local_var()
	elif current_node["node_type"] == "chance_branch":
		chance_branch()
	elif current_node["node_type"] == "dialogue_signal":
		emit_dialogue_signal()

func emit_dialogue_signal():
	emit_signal("dialogue_signal", current_node["signal"])
	
	auto_next()
	handle_current_node()

func chance_branch():
	var chance_1 = current_node["chance_1"]
	var chance_2 = current_node["chance_2"]
	
	var rand_num = randi() % int(chance_1 + chance_2) + 1
	
	if rand_num <= chance_1:
		current_node = get_dialogue_node_by_id(current_node["branches"]["1"])
	else:
		current_node = get_dialogue_node_by_id(current_node["branches"]["2"])
	
	handle_current_node()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func condition_branch():
	var condition = current_node["text"]
	
	if evaluate_value(condition):
		current_node = get_dialogue_node_by_id(current_node["branches"]["True"])
	else:
		current_node = get_dialogue_node_by_id(current_node["branches"]["False"])
	
	handle_current_node()

func evaluate_value(condition : String):
	var parts : PoolStringArray = condition.split(" ")
	var var_name : String = parts[0]
	var comparator : String = parts[1]
	var value : String = parts[2]
	
	var var_value = str(local[var_name])
	
	match comparator:
		"==": # Equality comparisions
			return var_value == value
		"!=":
			return var_value != value
		">=": # Number comparisions
			return float(var_value) >= float(value)
		"<=":
			return float(var_value) <= float(value)
		">":
			return float(var_value) > float(value)
		"<":
			return float(var_value) < float(value)
		
