extends Node



func _ready():
	get_node("AnimationPlayer").play("Fade in")
	yield(get_tree().create_timer(2), "timeout")
	get_node("AnimationPlayer").play("Fade Out")
	#yield(get_tree().create_timer(3), "timeout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
