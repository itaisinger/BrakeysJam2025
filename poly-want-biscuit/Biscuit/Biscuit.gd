extends Area2D

@onready var game_manager = %GameManager

func _ready():
	self.connect("area_entered",Col)
	pass

func Col(are: Area2D):
	game_manager.win()
	queue_free()
	pass
