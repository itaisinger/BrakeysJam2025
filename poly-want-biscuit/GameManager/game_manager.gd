extends Node

var keys = 0

enum STATES{game,death,win}
@onready var state = STATES.game

@onready var hud = $Hud
@onready var player = %Parot
@onready var camera = %camera

var camera_zoom_base
var timer = 0

func _process(delta):
	
	timer = max(0,timer-delta)
	
	match(state):
		STATES.game:
			pass
		STATES.death:
			if(Input.is_action_just_pressed("Jump")):
				get_tree().change_scene_to_file("res://Game/main_menu.tscn")
			pass
		STATES.win:
			var z = lerp(camera.zoom.x, camera_zoom_base*2,0.02)
			camera.zoom = Vector2(z,z)
			
			if(timer <= 0):
				get_tree().change_scene_to_file("res://Game/main_menu.tscn")
			pass
	pass

func got_key():
	keys += 1;
	hud.set_keys(keys)
	player.got_key()
	print(keys)

func win():
	print("won")
	player.WinAnim()
	state = STATES.win
	
	#camera
	camera_zoom_base = camera.zoom.x
	camera.drag_horizontal_enabled = false;
	camera.drag_vertical_enabled = false;
	
	#hud
	hud.win_screen()
	timer = 8;
	pass
	
func player_died():
	hud.death_screen()
	state = STATES.death
	print("entered death game state")
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b
