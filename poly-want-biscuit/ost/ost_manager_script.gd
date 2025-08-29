extends Node2D


@export var menuOst : AudioStream
@export var gameOst : AudioStream
@export var isMenu : bool = false
@onready var player = $player

func _ready():
	player.stream = menuOst if isMenu else gameOst
	player.play()
	
