extends Area2D
signal key_pickedup
@onready var game_manager = %GameManager


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("parrot"):
		game_manager.got_key();
		#emit_signal("key_pickedup")
		queue_free()
