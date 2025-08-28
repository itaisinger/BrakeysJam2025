extends Control
class_name main_menu

@export var start_audio: Array[AudioStream] = []
@export var buttons_audio: Array[AudioStream] = []

@onready var sfx_player = $AudioStreamPlayer
@onready var timer = $Timer

var starting = false

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_focus_entered() -> void:
	sfx_player.stream = buttons_audio[0]
	sfx_player.play()

func _on_quit_button_focus_entered() -> void:
	sfx_player.stream = buttons_audio[0]
	sfx_player.play()

func _on_start_button_pressed() -> void:
	var random_sfx = start_audio[randi() % start_audio.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
	starting = true
	timer.start()

func _on_quit_button_pressed() -> void:
	sfx_player.stream = buttons_audio[1]
	sfx_player.play()
	timer.start()
	

func _on_timer_timeout() -> void:
	if starting:
		get_tree().change_scene_to_file("res://Game/game.tscn")
	else:
		get_tree().quit()
		
		
