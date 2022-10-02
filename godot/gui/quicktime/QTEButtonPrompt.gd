extends Control

onready var texture_rect = get_node("CenterContainer/TextureRect")
onready var tween = get_node("Tween")

func _ready():
	tween.interpolate_property(texture_rect.material, "shader_param/line_thickness", 0.0, 1.0, 0.4, Tween.TRANS_QUAD)
	var initial_vec = Vector2(1.0, 1.0)
	var target_vec = Vector2(1.4, 1.4)
	tween.interpolate_property(texture_rect, "rect_scale", initial_vec, target_vec, 1.4, Tween.TRANS_QUAD)
	
	# tween.interpolate_property(texture_rect, "rect_scale", Vector2(1.0f, 1,0f), Vector2(1.4f, 1,4f), 4.0, Tween.TRANS_QUAD)
	tween.start()

