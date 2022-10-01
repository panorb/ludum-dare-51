extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var json_data = {}
var current_node 
var local_vars = {}
onready var dialogue_box : Control = get_node("DialogueBox")

# Called when the node enters the scene tree for the first time.
func _ready():
	start_dialogue("res://content/dialogue/_Intro_Part3.json")
	show_dialog_text()
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("option_select"):
		if(current_node["node_type"] == "show_message"):
			if(current_node["character"][0] != "Player"):
				show_dialog_text()
			else:
				dialogue_box.text = "[Choice skipped]"
				show_dialog_text(true)

func load_data(json_path):
	var file = File.new()
	file.open(json_path, File.READ)
	json_data = parse_json(file.get_as_text())
	file.close()
	
func get_dialogue_node_by_id(id):
	for node in json_data[0]["nodes"]:
		if node["node_name"] == id:
			return node
			
func find_start():
	for node in json_data[0]["nodes"]:
		if node["node_type"] == "start":
			return node

func create_variables():
	for variable in json_data[0]["variables"]:
		for name in variable.keys():
			local_vars[name] = variable[name]["value"]

func start_dialogue(json_path):
	load_data(json_path)
	create_variables()
	current_node = find_start()
	
func show_dialog_text(is_choice : bool = false):
	if is_choice:
		current_node = get_dialogue_node_by_id(current_node["choices"][0]["next"])
	else:
		current_node = get_dialogue_node_by_id(current_node["next"])
	if current_node["node_type"] == "show_message":
		dialogue_box.text = current_node["text"]["ENG"]
		dialogue_box.display_name = current_node["character"][0]
	elif current_node["node_type"] == "set_local_variable":
		if current_node["operation_type"] == "ADD":
			local_vars[current_node["var_name"]] += current_node["value"]
		if current_node["operation_type"] == "SUBSTRACT":
			local_vars[current_node["var_name"]] -= current_node["value"]
		if current_node["operation_type"] == "SET":
			local_vars[current_node["var_name"]] = current_node["value"]
		show_dialog_text()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
