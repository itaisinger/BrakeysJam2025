extends CharacterBody2D

#state machine
enum STATES { idle, air, collect, die, shout }
var state = STATES.air
var state_prev = state
var state_changed = false

#phy
var dir = 1 #1 for right
var grounded=false
var yspd=0
var yspd_max = 2.6
var grav=0.1
var jumpforce=2.5
var shoutforce=1
var xspd = 0
var natural_spd = 0.7
var press_spd = 3.6
var looking_left=true
var xfric = .3

#logic
var screech_visible=false
var dead=false
signal parrot_screech(word)
signal key_pickedup
var size = abs(scale.x)
var timer = 0

@onready var anim = $AnimatedSprite2D
@onready var anim_shout = $anim_shout


func _ready() -> void:
	preload("res://Game/main_menu.tscn")
	var root = get_tree().root.get_child(1)
	root.connect("key_pickedup",_key_pickedup)
	#anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	

func _key_pickedup():
	$Hud.add_key()
	print("key")
	state = STATES.collect;
	anim.play("collect")
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("restart")): get_tree().reload_current_scene()
	player_data.player_position=position
	#movement
	grounded = IsGrounded()
	if(!grounded): 
		yspd += grav
	
	#states
	state_prev = state
	match(state):
		STATES.idle: 	idle_state()
		STATES.air: 	air_state()
		STATES.collect: collect_state()
		STATES.shout: shout_state(delta)
		STATES.die: 	die_state()
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
		else:
			emit_signal("parrot_screech",Globals.VOICES.curse)
		Shout()
	pass
	
	
########### STATES FUNCTIONS ##############
	
func idle_state():
	if(state_changed): anim.play("idle")
	
	xspd *= 0.1
	xspd = approach(xspd,0,xfric/2)
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
	if(grounded): state = STATES.idle
	
	if(yspd > 0 && anim.animation == "jump"):
		anim.play("flying") 
	

func shout_state(delta):
	if(state_changed):
		$shout_spr.visible = true
		anim.visible = false
		timer = 1
	
	timer -= delta
	if(timer <= 0):
		if(grounded): state = STATES.idle
		else: 
			anim.play("flying")
			state = STATES.air
	pass

func collect_state():
	xspd = 0
	yspd = 0
	
	await anim.animation_finished
	yspd = -shoutforce
	state = STATES.air
	pass
		
func die_state():
	if(state_changed): anim.play("death")
	#signal die
	pass
	
	
	#########################################
	#
	#




##check this
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("enemies"):
		#Death()
		#pass

##check this
#func Death():
	#dead=true
	##anim.scale=Vector2(2,2)
	#$Hud.death_screan()
	#anim.play("death")
	#print("rip")

func ResetAnim():
	#if(state == STATES.idle): anim.play("idle")
	#if(state == STATES.air): anim.play("air")
	#match(state):
		#STATES.idle: 	anim.play("idle")
		#STATES.air: 	anim.play("air")
		#STATES.collect: anim.play("collect")
		#STATES.die: 	anim.play("die")
	pass
		
func IsGrounded() -> bool:
	for area in $"land hitbox".get_overlapping_areas():
		if(area.is_in_group("platforms")):
			return true
	return false
	
func Jump():
	yspd = -jumpforce;
	state = STATES.air;
	anim.play("jump")
	
func Shout():
	anim_shout.play("shout")
	anim.play("shout")
	yspd = -shoutforce
	state = STATES.shout
	timer = 1
	pass

func approach(val,target,spd) -> float:
	if(val < target): return min(target,val+spd)
	if(val > target): return max(target,val-spd)
	return val

func lerp(val,target,spd) -> float:
	if(val < target): return val + abs(spd*(target-val))
	if(val > target): return val + abs(spd*(target-val))
	return val

	
##check this
#func _on_land_detection_area_entered(area: Area2D) -> void:
	#if area.is_in_group("platforms"):
		#grounded=true
		#xspd=0
