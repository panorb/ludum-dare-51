extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json_data = {}
var current_node 
var local = {} # Stores local variables from the editor
var box_style : String = "Dialogue"

var dialogue_box_scene = preload("res://gui/dialogue/DialogueBox.tscn")
var choice_box_scene = preload("res://gui/dialogue/ChoiceBox.tscn")


onready var dialogue_box : Control = get_node("DialogueBox")
onready var choice_box : Control = get_node("ChoiceBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_dialogue("res://content/dialogue/Intro_Part3.json")
	dialogue_box.connect("reading_finished", self, "on_reading_finished")
	remove_child(choice_box)
	handle_current_node()
	pass # Replace with function body.

func toggle_box():
	if box_style == "Dialogue":
		remove_child(dialogue_box)
		choice_box = choice_box_scene.instance()
		add_child(choice_box)
		choice_box.connect("choice_selected", self, "on_choice_selected")
		box_style = "Choice"
	else:
		remove_child(choice_box)
		dialogue_box = dialogue_box_scene.instance()
		add_child(dialogue_box)
		dialogue_box.connect("reading_finished", self, "on_reading_finished")
		box_style = "Dialogue"

func load_data(json_path):
	var file = File.new()
	file.open(json_path, File.READ)
	json_data = parse_json(file.get_as_text())
	file.close()
	
	local = json_data[0]["variables"]
	
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
		local[var_name]["value"] += current_node["value"]
	if current_node["operation_type"] == "SUBSTRACT":
		local[var_name]["value"] -= current_node["value"]
	if current_node["operation_type"] == "SET":
		local[var_name]["value"] = current_node["value"]
	
	auto_next()
	handle_current_node()

func get_var(var_name):
	return local[var_name]["value"]

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
		if box_style == "Dialogue":
			toggle_box()
		choice_box.question = current_node["text"]["ENG"]
		var tmp = []
		for i in range(len(current_node["choices"])):
			tmp.append(current_node["choices"][i]["text"]["ENG"])
		choice_box.choices = tmp
	else:
		if box_style == "Choice":
			toggle_box()
		dialogue_box.text = current_node["text"]["ENG"]
		dialogue_box.display_name = current_node["character"][0]

func auto_next():
	if current_node and current_node.has("next"):
		current_node = get_dialogue_node_by_id(current_node["next"])
	else:
		current_node = null

func handle_current_node():
	if not current_node:
		dialogue_box.text = "Next Chapter"#assert(false, "Implement next chapter here")
	elif current_node["node_type"] == "condition_branch":
		condition_branch()
	elif current_node["node_type"] == "show_message":
		show_message()
	elif current_node["node_type"] == "set_local_variable":
		set_local_var()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func condition_branch():
	var c = current_node["text"]
	
	var parts : PoolStringArray = c.split(" ")
	var var_name : String = parts[0]
	var comparator : String = parts[1]
	var value : String = parts[2]
	
	if evaluate_value(var_name, comparator, value):
		current_node = get_dialogue_node_by_id(current_node["branches"]["True"])
	else:
		current_node = get_dialogue_node_by_id(current_node["branches"]["False"])
	
	handle_current_node()

func evaluate_value(var_name : String, comparator : String, value : String):
	var var_value = str(local[var_name]["value"])
	
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
		
