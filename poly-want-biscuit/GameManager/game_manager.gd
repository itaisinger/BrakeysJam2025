extends Node

var keys = 0
var keys_left = 7
enum STATES{game,death,win}
@onready var state = STATES.game

@onready var hud = $Hud
@onready var player = %Parot
@onready var camera = %camera
@onready var ost_manager = %OstManager

var camera_zoom_base
var timer = 0

func _ready():
	hud.set_keys(0,keys_left)
	randomize()
	

func _process(delta):
	
	if(Input.is_action_just_pressed("restart")): get_tree().reload_current_scene()
	if(Input.is_action_just_pressed("key")): got_key()
	
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
			camera.offset = Vector2(0, camera.offset.y * 0.1)
			camera.zoom = Vector2(z,z)
			
			if(timer <= 0):
				get_tree().change_scene_to_file("res://Game/main_menu.tscn")
			pass
	pass

func got_key():
	keys += 1;
	hud.set_keys(keys,keys_left)
	player.got_key()
	if(keys == keys_left):
		ost_manager.win()

func remove_key():
	keys -= 1
	keys_left -= 1
	hud.set_keys(keys,keys_left);

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
	var tween = create_tween()
	tween.tween_property(ost_manager,"volume",0,6).set_ease(Tween.EASE_IN)
	timer = 10;
	pass
	
func player_died():
	hud.death_screen()
	state = STATES.death
	print("entered death game state")
	pass

func lerp(a, b, t):
	return (1 - t) * a + t * b
