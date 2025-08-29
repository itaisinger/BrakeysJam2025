extends Node

@export var instances_parrot_voice: Array[AudioStream] = []
@export var curses_parrot_voice: Array[AudioStream] = []
@export var meow_parrot_voice: Array[AudioStream] = []
@export var get_key_parrot_voice: Array[AudioStream] = []
@export var fly_parrot_audio: Array[AudioStream] = []

var pos = Vector2(0,0)
@onready var sfx_player = $AudioStreamPlayer

func _process(delta: float) -> void:
	sfx_player.position = pos

func play_random_curse():
	var random_sfx = curses_parrot_voice[randi() % curses_parrot_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
func play_random_meow():
	var random_sfx = meow_parrot_voice[randi() % meow_parrot_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
func play_random_get_key_voiceline():
	var random_sfx = get_key_parrot_voice[randi() % get_key_parrot_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
func play_random_wing_flap():
	var random_sfx = fly_parrot_audio[randi() % fly_parrot_audio.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
func play_death_sound():
	sfx_player.stream = instances_parrot_voice[0]
	sfx_player.play()
func play_find_biscuit_sound():
	sfx_player.stream = instances_parrot_voice[1]
	sfx_player.play()
func play_eat_biscuit_sound():
	sfx_player.stream = instances_parrot_voice[2]
	sfx_player.play()
func play_speech_sound():
	sfx_player.stream = instances_parrot_voice[3]
	sfx_player.play()
