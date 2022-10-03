extends CenterContainer

var sequence = [] setget _set_sequence

var qte_button_scene = preload("res://gui/quicktime/QTEButton.tscn")
onready var prompts_node = get_node("%Prompts")
onready var progress_bar = get_node("%ProgressBar")

var current_prompt_idx = -1

signal qte_success
signal qte_timeout

var delta_sum : float = 0

func _process(delta):
	if current_prompt_idx > -1:
		delta_sum += delta
		if delta_sum >= 1:
			delta_sum = 0
			progress_bar.value -= 1
			
			if progress_bar.value <= 0:
				current_prompt_idx = -1
				emit_signal("qte_timeout")


func _set_sequence(new_val):
	sequence = new_val
	
	for prompt_node in prompts_node.get_children():
		prompt_node.queue_free()
	
	for btn_action in sequence:
		var new_node = qte_button_scene.instance()
		prompts_node.add_child(new_node)
		new_node.button = btn_action
	
	progress_bar.value = 10
	
	current_prompt_idx = 0
	prompts_node.get_child(0).highlight()
	SoundController.play_music("ticking.wav", 1)

func _input(event):
	if current_prompt_idx >= 0 and event.is_action_pressed(sequence[current_prompt_idx]):
		prompts_node.get_child(current_prompt_idx).gray_out()
		
		if current_prompt_idx + 1 < prompts_node.get_child_count():
			prompts_node.get_child(current_prompt_idx + 1).highlight()
			current_prompt_idx += 1
		else:
			SoundController.stop_music(1)
			emit_signal("qte_success")
