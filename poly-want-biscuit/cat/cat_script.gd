extends CharacterBody2D

enum CAT_STATES{
	sleep,
	walk,
	jump,
	dead,
	hold
}

var state
var player_pos
var dir = 1
#physics
var yspd = 0
var xspd = 0
var grounded = true
var grav = 0.03
var just_died=true

#bhvr vars
var hear_distance = 600
var awake_dis = 150
var jumpforce = 1
var spd = 1

var voice_cooldown := 0.0
var screechable=true
var timer=0
const VOICE_COOLDOWN_TIME := 6.0
signal parrot_flap
signal parrot_screech(word)

@onready var sfx_player = $AudioStreamPlayer
@onready var anim_walk = $anim_walk
@onready var anim_normal = $anim

@export var cat_wakeup_voice: Array[AudioStream] = []
@export var cat_cought_react: Array[AudioStream] = []
@export var cat_jump_voice: Array[AudioStream] = []
@export var cat_sleep_voice: Array[AudioStream] = []




func _ready() -> void:
	state = CAT_STATES.sleep
	anim_normal.play("sleep")
	var root = get_tree().root.get_child(1)
	root.connect("parrot_screech",hear_sound)
	root.connect("parrot_flap",_parrot_flap)
	#level.connect("emit_sound",hear_sound)


func _parrot_screech(word):
	pass
	
func _parrot_flap():
	pass
func _physics_process(delta: float) -> void:
	grounded=is_grounded()
	player_pos = player_data.player_position
	if(state == CAT_STATES.sleep):
		state_sleep()
	if(state == CAT_STATES.walk):
		state_walk()
	if(state == CAT_STATES.jump):
		state_jump()
	if(state == CAT_STATES.dead):
		state_dead()
	if(state == CAT_STATES.hold):
		state_hold(delta)
	if(grounded): yspd = 0
	
	#position.y+=yspd
	move_and_collide(Vector2(xspd,yspd))
	
	#visuals
	anim_normal.visible = state != CAT_STATES.walk
	anim_walk.visible = state == CAT_STATES.walk


func state_sleep() -> void:
	if position.distance_to(player_data.player_position)<1000:
		sfx_player.stream = cat_sleep_voice[0]
		sfx_player.play()
	if(player_pos.distance_to(position) < awake_dis):
		print("waking up")
		#position.y-=50
		#grounded=false
		#state_walk()
		#if (position.x>player_data.player_position.x):
			#moving_left=false
			#dir=-1
		#else:
			#moving_left=true
			#dir=1
		#if dir<0:
			#scale.x = abs(scale.x)
		#else:
			#scale.x = -abs(scale.x)
		update_dir()
		state = CAT_STATES.hold
		timer = 2

func is_grounded():
	for area in $ground_delection.get_overlapping_areas():
		if area.is_in_group("platforms"):
			return true
	return false
	
func state_walk() -> void:
	#walk
	position.x += dir * spd
	yspd = 0
	position.y += grav*4
	if(!grounded):
		print("ungroundeed")
		state = CAT_STATES.hold
		timer = 1
func state_hold(delta_time) -> void:
	update_dir()
	anim_normal.play("hold")
	timer -= delta_time
	yspd = 0
	if(timer <= 0):
		jump()
func state_jump() -> void:
	#fall
	position.x += dir * spd*5
	yspd += grav
	position.y += yspd
	if(grounded): state = CAT_STATES.dead
func state_dead() -> void:
	#make sure the cat doesnt have a hitbox here
	if just_died:
		$anim.play("dead")
		just_died=false
		$Area2D.monitorable = false
	pass

func jump() -> void:
	#$ground_delection.monitoring = false;
	#no_col_cd = 
	position.y -= 10 #get out of ground
	yspd -= jumpforce*2
	state = CAT_STATES.jump
	anim_normal.play("jump")
	var random_sfx = cat_jump_voice[randi() % cat_jump_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
	voice_cooldown = VOICE_COOLDOWN_TIME 
func update_dir() -> void:
	dir = -sign(position.x-player_pos.x)
	print("==")
	print(dir)
	if dir == 1:
		transform.x = Vector2(abs(scale.x),0)
	else:
		transform.x = Vector2(-abs(scale.x),0)
	print(scale.x)

func hear_sound(voice) -> void:
	print(" cat recognise screech")
	if position.distance_to(player_data.player_position)>hear_distance or !screechable:
		pass

	else:
		screechable=false
		$Timer.start(6)
		dir = -sign(position.x - player_pos.x)
		var random_sfx = cat_wakeup_voice[randi() % cat_wakeup_voice.size()]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME 
		if(voice == Globals.VOICES.meow):
			#play happy meow sound
			state = CAT_STATES.walk
			anim_normal.play("walk")
			#dir = towards pos
		if(voice == Globals.VOICES.curse):
			#play angry meow sound
			state = CAT_STATES.walk
			anim_normal.play("walk")
			dir = -dir
		if dir<0:
			scale.x = abs(scale.x)
		else:
			scale.x = -abs(scale.x)

func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("platforms"):
		#	grounded=true
	if area.is_in_group("parrot"):
		var random_sfx = cat_cought_react[randi() % cat_cought_react.size()]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME 


#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if area.is_in_group("platforms"):
		#grounded=false
func _on_timer_timeout() -> void:
	screechable=true
