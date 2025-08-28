extends RigidBody2D

@onready var game_manager = %GameManager
@onready var anim = $key_anim
@export var explosion : PackedScene

func _ready():
	$"interact box".connect("area_entered",interact)
	$collision.scale = $Sprite2D.scale
	$"interact box".scale = $Sprite2D.scale
	#explosion = preload("res://platform/explosion.tscn")
	
	pass
	
func interact(area: Area2D):
	if area.is_in_group("parrot") && game_manager.keys > 0:
		game_manager.remove_key();
		var ex = explosion.instantiate()
		ex.position = position
		get_parent().add_child(ex)
		queue_free()
	pass
	
