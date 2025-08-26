extends Area2D

@onready var game_manager = %GameManager

func _on_body_entered(body: Node2D) -> void:
	print("Congrats!")
	queue_free()
	game_manager.win()
