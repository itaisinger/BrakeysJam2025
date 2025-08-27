extends CharacterBody2D

#state machine
enum STATES { idle, air, collect, die }
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
var xspd = 0
var natural_spd = 0.7
var press_spd = 3.6
var looking_left=true
var xfric = .3

#logic
var screech_visible=false
var dead=false
signal parrot_flap
signal parrot_screech(word)
var size = abs(scale.x)

@onready var anim = $AnimatedSprite2D


func _ready() -> void:
	preload("res://Game/main_menu.tscn")
	#anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	


func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("restart")): get_tree().reload_current_scene()
	
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
		STATES.die: 	die_state()
	state_changed = state_prev != state
	
	#move	
	yspd = min(yspd,yspd_max)
	position += Vector2(xspd,yspd)
	move_and_slide()
	
	#visuals
	anim.scale.x = dir * abs(anim.scale.x)
	
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
	
	
func collect_state():
	pass
		
func die_state():
	if(state_changed): anim.play("death")
	#signal die
	pass
	
	
	#########################################
	#
	#
	#if Input.is_action_just_pressed("Jump"):
		#emit_signal("parrot_flap")
		#current_status=Status.JUMPING
		#grounded=false
		#match current_state:
			#"LEFT":
				#xspd=xfric
			#"RIGHT":
				#xspd=-xfric
	#
	#if Input.is_action_just_pressed("Curse") or Input.is_action_just_pressed("Meow") :
		#if Input.is_action_just_pressed("Meow"):
			#emit_signal("parrot_screech",Globals.VOICES.meow)
		#else: emit_signal("parrot_screech",Globals.VOICES.curse)
		#$Sprite2D.visible=true
		#for i in range(11):
			#await get_tree().create_timer(0.1).timeout
			#$Sprite2D.visible=screech_visible
			#screech_visible=!screech_visible
		#$Sprite2D.visible=false


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

func IsGrounded() -> bool:
	for area in $"land hitbox".get_overlapping_areas():
		if(area.is_in_group("platforms")):
			return true
	return false
	
func Jump():
	yspd = -jumpforce;
	state = STATES.air;
	anim.play("jump")

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
