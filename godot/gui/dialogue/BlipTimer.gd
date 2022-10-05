extends Timer

export(float, 0.0, 0.05) var animation_duration_per_char = 0.014
export(Array, String, FILE) var sound_file = ["default_blip.wav"]
export(float, 0.01, 4.0) var pitch_scale = 1.0

var _current_blip_index = 0

func _ready():
	self.connect("timeout", self, "_on_self_timeout")

func _on_self_timeout():
	_current_blip_index += 1
	if _current_blip_index >= len(sound_file):
		_current_blip_index = 0

func get_current_sound_file():
	return sound_file[_current_blip_index]
