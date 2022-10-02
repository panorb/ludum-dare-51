extends CenterContainer

var sequence = [] setget _set_sequence

var qte_button_scene = preload("res://gui/quicktime/QTEButton.tscn")
onready var prompts_node = get_node("Prompts")

func _set_sequence(new_val):
	sequence = new_val
	
	for prompt_node in prompts_node.get_children():
		prompt_node.queue_free()
	
	for btn_action in sequence:
		var new_node = qte_button_scene.instance()
		prompts_node.add_child(new_node)
		new_node.button = btn_action

func _ready():
	self.sequence = ["qte_up", "qte_left", "qte_a", "qte_x", "qte_y"]
