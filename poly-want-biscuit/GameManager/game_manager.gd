extends Node

var keys = 0

enum STATES{game,death,win}
@onready var state = STATES.game

@onready var hud = $Hud
@onready var player = %Parot

func _process(delta):
	match(state):
		STATES.game:
			pass
		STATES.death:
			if(Input.is_action_just_pressed("Jump")):
				print("game step")
				get_tree().change_scene_to_file("res://Game/main_menu.tscn")
			pass
		STATES.win:
			if(Input.is_action_just_pressed("restart")):
				load("res://Game/main_menu.tscn")
			pass
	pass

func got_key():
	keys += 1;
	hud.set_keys(keys)
	player.got_key()
	print(keys)

func win():
	print("won")
	pass
	
func player_died():
	hud.death_screen()
	state = STATES.death
	print("entered death game state")
	pass
