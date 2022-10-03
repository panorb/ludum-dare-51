extends Control

var keyboard_atlas : AtlasTexture = preload("keyboard.atlastex")
var xbox_atlas : AtlasTexture = preload("xbox.atlastex")

var button = "qte_a" setget _set_button

onready var texture_rect = get_node("TextureRect")
onready var tween : Tween = get_node("Tween")
onready var pressed_animation_timer = get_node("PressedAnimationTimer")

var _animate_press = false
var _show_pressed = false

var _button_map = {
	"qte_a": 0,
	"qte_b": 1,
	"qte_x": 2,
	"qte_y": 3,
	"qte_down": 5,
	"qte_left": 6,
	"qte_right": 7,
	"qte_up": 8 
}

func _ready():
	texture_rect.texture = xbox_atlas.duplicate()
	texture_rect.material = texture_rect.material.duplicate()

func _on_pressed_animation_timeout():
	if _animate_press:
		_show_pressed = not _show_pressed
		_update_displayed_button()

func _input(event):
	if event is InputEventJoypadButton:
		texture_rect.texture = xbox_atlas.duplicate()
	elif event is InputEventKey:
		texture_rect.texture = keyboard_atlas.duplicate()

	_update_displayed_button()

func _set_button(new_val : String):
	assert(_button_map.has(new_val), "Button unknown")
	button = new_val
	_update_displayed_button()
	
func _update_displayed_button():
	var image_index = _button_map[button]
	var texture_atlas : AtlasTexture = texture_rect.texture
	
	texture_atlas.region = Rect2(image_index * 16, int(_show_pressed) * 16, 16, 16)

func highlight():
	tween.remove_all()
	tween.interpolate_property(texture_rect.material, "shader_param/line_thickness", 0.0, 1.0, 0.2, Tween.TRANS_QUAD)
	tween.interpolate_property(texture_rect, "rect_scale", Vector2(1.0, 1.0), Vector2(1.2, 1.2), 0.3, Tween.TRANS_QUAD)
	tween.start()
	
	_animate_press = true
	
func gray_out():
	texture_rect.material["shader_param/line_thickness"] = 0.0
	tween.remove_all()
	tween.interpolate_property(texture_rect, "rect_scale", Vector2(1.2, 1.2), Vector2(0.7, 0.7), 0.1, Tween.TRANS_QUAD)
	tween.start()
	
	_animate_press = false
	_show_pressed = true
