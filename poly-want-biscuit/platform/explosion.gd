extends Node2D

@export var snd1 : AudioStream
@export var snd2 : AudioStream

func _ready():
	$AudioStreamPlayer2D.stream = snd1 if (randf() < 0.5) else snd2
	$AudioStreamPlayer2D.play()
	$sprite.connect("animation_finished",ended)
	
func ended():
	queue_free()
