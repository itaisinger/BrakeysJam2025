extends Area2D

@onready var game_manager = %GameManager

func _process(delta: float) -> void:
	print("Congrats!")
	queue_free()
	game_manager.win()
