extends Node2D

func _ready():
	$AudioStreamPlayer2D.play()
	$sprite.connect("animation_finished",ended)
	
func ended():
	queue_free()
