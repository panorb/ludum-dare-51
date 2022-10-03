extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var time_stealer = get_node("TimeStealer")
onready var health_bar_time_stealer = get_node("Control/HealthBarTimeStealer")

var position_left_up : Vector2 = Vector2(24,48)

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar_time_stealer.max_value = time_stealer.health
	health_bar_time_stealer.step = 1
	health_bar_time_stealer.value = time_stealer.health
	init_positions()

func init_positions():
	time_stealer.position = position_left_up + (2 * Vector2(0,48)) + Vector2(350,24)
	health_bar_time_stealer.rect_position = time_stealer.position + Vector2(0, -96) - health_bar_time_stealer.rect_pivot_offset

func change_value_health_bar(value : int):
	if value < 0:
		value = 0
	health_bar_time_stealer.value = value
	if health_bar_time_stealer.value <= (health_bar_time_stealer.max_value / 2):
		health_bar_time_stealer.get("custom_styles/fg").set_bg_color(Color(1.0, 0.853, 0.0, 1.0))
	if health_bar_time_stealer.value <= (health_bar_time_stealer.max_value / 10):
		health_bar_time_stealer.get("custom_styles/fg").set_bg_color(Color(1.0, 0.0, 0.0, 1.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
