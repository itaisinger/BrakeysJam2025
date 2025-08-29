extends Node2D


@export var menuOst : AudioStream
@export var gameOst : AudioStream
@export var isMenu : bool = false
@export_range(0,1,0.01) var volume : float = 0.5
@onready var player = $player

func _ready():
	player.stream = menuOst if isMenu else gameOst
	player.play()
	
func _process(delta: float) -> void:
	player.volume_db = lerp(-30,0,volume)
	
