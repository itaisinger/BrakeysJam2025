extends Area2D

@onready var game_manager = %GameManager

func _process(delta: float) -> void:
	game_manager.got_key()
	queue_free()
 
