extends Area2D
signal key_pickedup
@onready var game_manager = %GameManager
 
#func _on_body_entered(body: Node2D) -> void:
 		#game_manager.got_key()
		#queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("parrot"):
		emit_signal("key_pickedup")
		queue_free()
