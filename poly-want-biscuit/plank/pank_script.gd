extends Area2D

@onready var game_manager = %GameManager
@onready var anim = $key_anim
func _ready():
	$"interact box".connect("area_entered",interact)
	pass
	
func interact(area: Area2D):
	if area.is_in_group("parrot") && game_manager.keys > 0:
		game_manager.remove_key();
		queue_free()
	pass
