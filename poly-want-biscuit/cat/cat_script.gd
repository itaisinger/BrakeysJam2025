extends CharacterBody2D

enum CAT_STATES{
	sleep,
	walk,
	jump,
	dead
}

var state
var hear_distance
var player_pos
var walk_dir = 1

#physics
var yspd = 0
var grounded = true
var grav = 0.2

#bhvr vars
var awake_dis = 20;
var jumpforce = 5
var spd = 3

	
func _ready() -> void:
	print("cat ready")
	var state = CAT_STATES.sleep
	var hear_distance = 50
	
func _physics_process(delta: float) -> void:
	
	grounded = standing_on_wall	#insert smt here !!!!
	
	if(state == CAT_STATES.sleep):
		state_sleep()
	if(state == CAT_STATES.walk):
		state_walk()
	if(state == CAT_STATES.jump):
		state_jump()
	if(state == CAT_STATES.dead):
		state_dead()
		
func state_sleep() -> void:
	if(player_pos.distance_to(position) < awake_dis):
		dir = direction to player
		jump()
	
func state_walk() -> void:
	#walk
	position.x += dir * spd
	yspd = 0
	
	#jump
	if(!grounded):
		jump()
		
	
func state_jump() -> void:
	#fall
	yspd += grav
	position.y += yspd
	position.x += dir * spd
	
	if(grounded): state = CAT_STATES.dead
	
func state_dead() -> void:
	#make sure the cat doesnt have a hitbox here
	pass
	

func jump() -> void:
	yspd -= jumpforce
	state = CAT_STATES.jump
	
func hear_sound(voice, pos) -> void:
	if(position.distance_to(pos) > hear_distance):
		return
	if(voice == Globals.VOICES.meow):
		play happy mew sound
		state = CAT_STATES.walk
		dir = towards pos
		return
	if(voice == Globals.VOICES.curse):
		play angry meow sound
		state = CAT_STATES.walk
		dir = away from pos
