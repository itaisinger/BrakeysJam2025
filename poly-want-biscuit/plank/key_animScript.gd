extends AnimatedSprite2D

@onready var parent = get_parent()

func _ready() -> void:
	position.y += randf_range(-10,10)
func _process(delta):
	rotation = 0
	scale = Vector2(0.14,0.115)
