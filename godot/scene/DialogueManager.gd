extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json_data = {}
var current_node 
var local = {} # Stores local variables from the editor
var box_style : String = "Dialogue"
onready var dialogue_box : Control = get_node("DialogueBox")
onready var choice_box : Control = get_node("ChoiceBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_dialogue("res://content/dialogue/_Intro_Part3.json")
	dialogue_box.connect("reading_finished", self, "on_reading_finished")
	remove_child(choice_box)
	show_dialog_text()
	pass # Replace with function body.

func toogle_box():
	if box_style == "Dialogue":
		remove_child(dialogue_box)
		add_child(choice_box)
		choice_box.connect("choice_selected", self, "on_choice_selected")
		box_style = "Choice"
	else:
		remove_child(choice_box)
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

func set_var(var_name):
	if current_node["operation_type"] == "ADD":
		local[var_name]["value"] += current_node["value"]
	if current_node["operation_type"] == "SUBSTRACT":
		local[var_name]["value"] -= current_node["value"]
	if current_node["operation_type"] == "SET":
		local[var_name]["value"] = current_node["value"]

func get_var(var_name):
	return local[var_name]["value"]

func start_dialogue(json_path):
	load_data(json_path)
	current_node = find_start()
	
func on_choice_selected(choice_index):
	current_node = get_dialogue_node_by_id(current_node["choices"][choice_index]["next"])
	toogle_box()
	show_dialog_text(true)
	
func on_reading_finished():
	show_dialog_text()
	
func show_dialog_text(choice_seleceted : bool = false):
	if current_node["node_type"] == "condition_branch":
		print("Here")
		condition_branch()
	elif current_node["next"] != null:
		print(local["Time"]["value"])
		if !choice_seleceted:
			current_node = get_dialogue_node_by_id(current_node["next"])
			
		if current_node["node_type"] == "show_message" && current_node["character"][0] == "Player":
			toogle_box()
			choice_box.question = current_node["text"]["ENG"]
			var tmp = []
			for i in range(len(current_node["choices"])):
				tmp.append(current_node["choices"][i]["text"]["ENG"])
			choice_box.choices = tmp
			print(current_node["node_name"])
		elif current_node["node_type"] == "show_message":
			dialogue_box.text = current_node["text"]["ENG"]
			dialogue_box.display_name = current_node["character"][0]
		elif current_node["node_type"] == "set_local_variable":
			set_var(current_node.var_name)
			show_dialog_text()
	else:
		dialogue_box.text = "Ende Kapitel"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func condition_branch():
	var c = current_node.text

	if evaluate_value(c):
		current_node = get_dialogue_node_by_id(current_node["branches"]["True"])
	else:
		current_node = get_dialogue_node_by_id(current_node["branches"]["False"])

func evaluate_value(input):
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	printt("OBJ.EVAL()", obj.eval())
	return obj.eval()
