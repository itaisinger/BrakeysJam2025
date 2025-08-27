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
#bhvr vars
var hear_distance = 600
var awake_dis = 100;
var jumpforce = 1
var spd = 1
var moving_left=false
<<<<<<< Updated upstream
signal parrot_flap
signal parrot_screech(word)

	
=======
var voice_cooldown := 0.0
var screechable=true
var timer=0
const VOICE_COOLDOWN_TIME := 6.0
signal parrot_flap
signal parrot_screech(word)

@onready var sfx_player = $AudioStreamPlayer
@onready var anim_walk = $animation_walk
@onready var anim_normal = $animation

@export var cat_wakeup_voice: Array[AudioStream] = []
@export var cat_cought_react: Array[AudioStream] = []
@export var cat_jump_voice: Array[AudioStream] = []
@export var cat_sleep_voice: Array[AudioStream] = []



>>>>>>> Stashed changes
func _ready() -> void:
	state = CAT_STATES.sleep
	$animation.play("sleep")
	var root = get_tree().root.get_child(1)
	root.connect("parrot_screech",hear_sound)
	root.connect("parrot_flap",_parrot_flap)
	$"movement col".top_level = false
	#level.connect("emit_sound",hear_sound)


func _parrot_screech(word):
	pass
	
func _parrot_flap():
	pass
func _physics_process(delta: float) -> void:
<<<<<<< Updated upstream
=======
	yspd+=grav
	
	if voice_cooldown > 0.0:
		voice_cooldown -= delta
>>>>>>> Stashed changes
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
		
	print(grounded)
	
	position.y+=yspd
	move_and_collide(Vector2(xspd,yspd))
	
	#visuals
	anim_normal.visible = state != CAT_STATES.walk
	anim_walk.visible = state == CAT_STATES.walk


func state_sleep() -> void:
	if(player_pos.distance_to(position) < awake_dis):
		dir = -sign(position.x - player_pos.x) 
		jump()
	
		
	
func state_walk() -> void:
	#walk
	position.x += dir * spd
	yspd = 0
	#grav=0.2
	position.y += grav*4
	#jump
	if(!grounded):
		state = CAT_STATES.hold
		timer = 2
		
func state_hold(delta_time) -> void:
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
	pass


func jump() -> void:
	 
	yspd -= jumpforce*2
	state = CAT_STATES.jump
<<<<<<< Updated upstream
	$AnimatedSprite2D.play("jump")
=======
	anim_normal.play("jump")
	var random_sfx = cat_jump_voice[randi() % cat_jump_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
	voice_cooldown = VOICE_COOLDOWN_TIME 
	update_dir()

func update_dir() -> void:
>>>>>>> Stashed changes
	moving_left=position.x>player_pos.x
	if moving_left:
		scale.x = -1 * abs(scale.x)
	else:
		scale.x = abs(scale.x)

func hear_sound(voice) -> void:
<<<<<<< Updated upstream
	grav=0.2
	dir = -sign(position.x - player_pos.x) 
	if(voice == Globals.VOICES.meow):
		#play happy meow sound
		state = CAT_STATES.walk
		$AnimatedSprite2D.play("walk")
		#dir = towards pos
	if(voice == Globals.VOICES.curse):
		#play angry meow sound
		state = CAT_STATES.walk
		$AnimatedSprite2D.play("walk")
		dir = -dir
	if dir<0:
		$AnimatedSprite2D.flip_h=false
=======
	update_dir()
	if position.distance_to(player_data.player_position)>hear_distance or !screechable:
		pass
>>>>>>> Stashed changes
	else:
		screechable=false
		$Timer.start(6)
		#grav=0.2
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
	if area.is_in_group("platforms"):
		grounded=true
<<<<<<< Updated upstream

=======
	if area.is_in_group("parrot"):
		var random_sfx = cat_cought_react[randi() % cat_cought_react.size()]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME 
>>>>>>> Stashed changes

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("platforms"):
		grounded=false

func _on_timer_timeout() -> void:
	screechable=true
