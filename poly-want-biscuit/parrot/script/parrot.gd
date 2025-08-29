extends CharacterBody2D

#state machine
enum STATES { idle, air, collect, die, shout, win }
var state = STATES.air
var state_prev = state
var state_changed = false

#phy
var dir = 1 #1 for right
var grounded=false
var yspd=0
var yspd_max = 2.6
var grav=0.1
@export var grav_scale = 0.5 #used to make vertical jumps stronger
@export var jumpforce : float = 2.5
var shoutforce=1
var xspd = 0
var natural_spd = 0.7
var press_spd = 3.6
var looking_left=true
var xfric = .3

#logic
var screech_visible=false
signal parrot_screech(word)
signal key_pickedup
var size = abs(scale.x)
var timer = 0

@onready var anim = $AnimatedSprite2D
@onready var anim_shout = $anim_shout
@onready var game_manager = %GameManager
@onready var sfx_player = $sfx_player
@onready var black_screen  = %black_screen


func _ready() -> void:
	preload("res://Game/main_menu.tscn")
	var root = get_tree().root.get_child(1)
	#root.connect("key_pickedup",_key_pickedup)
	$hitbox.connect("area_entered",nmeCollided)
	#anim.connect("animation_finished", Callable(self, "_on_animation_finished"))


func _physics_process(delta: float) -> void:
	sfx_player.pos = position
	player_data.player_position=position
	#movement
	grounded = IsGrounded()
	if(!grounded): 
		var g = grav
		if(yspd < 0 and abs(xspd) < press_spd): g *= grav_scale
		yspd += g
	
	#states
	state_prev = state
	match(state):
		STATES.idle: 	idle_state()
		STATES.air: 	air_state()
		STATES.collect: collect_state()
		STATES.shout: 	shout_state(delta)
		STATES.die: 	die_state(delta)
		STATES.win: 	win_state()
	state_changed = state_prev != state
	
	#move
	yspd = min(yspd,yspd_max)
	position += Vector2(xspd,yspd)
	move_and_slide()
	
	#visuals
	anim.scale.x = dir * abs(anim.scale.x)
	anim_shout.scale.x = dir * abs(anim_shout.scale.x)
	
	#actions
	if Input.is_action_just_pressed("Curse") or Input.is_action_just_pressed("Meow") :
		if Input.is_action_just_pressed("Meow"):
			emit_signal("parrot_screech",Globals.VOICES.meow)
			sfx_player.play_random_meow()
		else:
			emit_signal("parrot_screech",Globals.VOICES.curse)
			sfx_player.play_random_curse()
		Shout()
	pass
	
	
########### STATES FUNCTIONS ##############
func idle_state():
	if(state_changed): anim.play("idle")
	
	xspd *= 0.1
	#xspd = approach(xspd,0,xfric/2)
	yspd = 0
	
	if(!grounded): state = STATES.air
	if(Input.is_action_just_pressed("Jump")): Jump()
	if(Input.is_action_pressed("Look_Right")): dir = 1
	if(Input.is_action_pressed("Look_Left")): dir = -1
	pass
func air_state():
	
	xspd = natural_spd
	if(Input.is_action_pressed("Look_Left")): 
		dir = -1
		xspd = press_spd
	if(Input.is_action_pressed("Look_Right")): 
		dir = 1
		xspd = press_spd
	
	xspd = xspd * dir
	
	if(Input.is_action_just_pressed("Jump")): Jump()
	if(grounded && yspd > 0): state = STATES.idle
	
	if(yspd > 0 && anim.animation == "jump"):
		anim.play("flying") 
func shout_state(delta):
	if(state_changed):
		$shout_spr.visible = true
		anim.visible = false
		timer = 1
	
	timer -= delta
	if(timer <= 0):
		if(grounded): 
			state = STATES.idle
		else: 
			anim.play("flying")
			state = STATES.air
	pass
func collect_state():
	xspd = 0
	yspd = 0
	
	await anim.animation_finished
	yspd = -shoutforce
	anim.play("flying")
	state = STATES.air
	pass
func die_state(delta):
	timer += delta
	if(timer <= 0.15):
		xspd = approach(xspd,0,xfric*0.1)
		yspd += grav/2
	elif(timer <= 0.7):
		xspd = approach(xspd,0,xfric*0.2)
		yspd = 0
		scale = Vector2(lerp(scale.x,9.0,0.2),lerp(scale.x,9.0,0.2))
	elif(timer <= 1.9):
		yspd = 0
		xspd = 0
	elif(timer <= 3):
		yspd = 0.5
	else:
		yspd = 0.5
		black_screen.modulate.a = approach(black_screen.modulate.a,1,0.01)
		#black_screen.z_index = z_index-1
		black_screen.position = position
	#signal die
	pass
func win_state():
	xspd = 0
	yspd = 0
	pass
#########################################

func nmeCollided(area):
	print("nme collided")
	if area.is_in_group("enemies"):
		Death()
	pass

func Death():
	state = STATES.die
	anim.play("death")
	z_index = 1000
	sfx_player.play_death_sound()
	visibility_layer = 10
	game_manager.player_died()
	yspd -= jumpforce
	xspd = -dir * jumpforce * 2
	$hitbox.queue_free()
	$"land hitbox".queue_free()
	$"collision hitbox".queue_free()
	timer = 0
	
func lerp(a, b, t):
	return (1 - t) * a + t * b

func IsGrounded() -> bool:
	if(state == STATES.die): return false
	for area in $"land hitbox".get_overlapping_areas():
		if(area.is_in_group("platforms")):
			return true
	return false
	
func Jump():
	yspd = -jumpforce;
	state = STATES.air;
	sfx_player.play_random_wing_flap()
	anim.play("jump")
	
func Shout():
	anim_shout.play("shout")
	anim.play("shout")
	yspd = -shoutforce
	state = STATES.shout
	timer = 1
	pass

func got_key():
	state = STATES.collect;
	sfx_player.play_random_get_key_voiceline()
	anim.play("collect")

func WinAnim():
	anim.play("win")
	state = STATES.win

func approach(val,target,spd) -> float:
	if(val < target): return min(target,val+spd)
	if(val > target): return max(target,val-spd)
	return val
