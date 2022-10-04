extends Node

const MUSIC_LAYERS: int = 3
const EFFECT_LAYERS: int = 20
var _effect: Array = []
var _music: Array = []
onready var _tween: Tween = null

# Playback Options
var _loop: bool = true

func _ready() -> void:
	_tween = Tween.new()
	add_child(_tween)
	
	for i in range(MUSIC_LAYERS):
		_music.append(AudioStreamPlayer.new())
		_music[i].bus = str("BGM",i)
		_music[i].volume_db = linear2db(Globals.music_volume)
		add_child(_music[i])
	
	for i in range(EFFECT_LAYERS):
		_effect.append(AudioStreamPlayer.new())
		_effect[i].volume_db = linear2db(Globals.effect_volume)
		_effect[i].bus = str("SFX",i)
		add_child(_effect[i])

func get_audio_effect_player(channel: int) -> AudioStreamPlayer:
	return _effect[channel]

func play_music(filename: String, channel: int = 0, \
	volume : float = -1, should_loop: bool = true) -> void:
	if volume < 0:
		volume = Globals.music_volume
	
	var path = "res://sounds/" + filename
	
	var stream = load(path)
	_music[channel].volume_db = linear2db(volume)
	_music[channel].stop()
	_music[channel].stream = stream
	_music[channel].play()
	_loop=should_loop

func load_music(filename: String, channel: int = 0):
	var path = "res://sounds/" + filename
	var stream = load(path)
	_music[channel].stream = stream

func play_channel(channel: int = 0, should_loop: bool = true):
	_music[channel].play()
	_loop=should_loop

func crossfade_music_channels(channel_from : int, channel_to : int):
	var from = _music[channel_from]
	var to = _music[channel_to]
	
	_tween.remove_all()
	_tween.interpolate_property(to, "volume_db", -100, linear2db(Globals.music_volume), 2.5, Tween.TRANS_LINEAR)
	_tween.interpolate_property(from, "volume_db", from.volume_db, -100, 5.0, Tween.TRANS_LINEAR)
	_tween.start()

func set_music_volume(channel: int, volume : float = -1):
	if volume < 0:
		volume = Globals.music_volume
	
	_music[channel].volume_db = linear2db(volume)

func set_effect_volume(channel: int, volume : float = -1):
	if volume < 0:
		volume = Globals.effect_volume
		
	_effect[channel].volume_db = linear2db(volume)

var effect_channel_idx = -1

func play_effect(filename: String, pitch_scale : float = 1, volume : float = -1) -> void:
	effect_channel_idx += 1
	
	if volume < 0:
		volume = Globals.effect_volume
	
	if effect_channel_idx >= len(_effect):
		effect_channel_idx = 0
	
	var path = "res://sounds/" + filename
	
	var stream = load(path)
	_effect[effect_channel_idx].pitch_scale = pitch_scale
	_effect[effect_channel_idx].volume_db = linear2db(volume)
	_effect[effect_channel_idx].stop()
	_effect[effect_channel_idx].stream = stream
	_effect[effect_channel_idx].play()


func stop_music(channel: int = -1)-> void:
	if channel < 0:
		for i in range(MUSIC_LAYERS):
			_music[i].stop()
			_music[i].stop()
			_music[i].stop()
	else:
		_music[channel].stop()
		_music[channel].stop()
		_music[channel].stop()

func stop_effect(channel: int) -> void:
	_effect[channel].stop()


func stop_effects()-> void:
	for i in range(0,EFFECT_LAYERS):
		_effect[i].stop()


func stop_all() -> void:
	stop_music()
	stop_effects()
