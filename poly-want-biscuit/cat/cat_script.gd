extends CharacterBody2D

enum CAT_STATES{
	sleep,
	walk,
	jump,
	dead
}

var state
var player_pos
var dir = 1
#physics
var yspd = 0
var grounded = true
var grav = 0.2
#bhvr vars
var hear_distance = 60
var awake_dis = 200;
var jumpforce = 5
var spd = 3
var moving_left=false
var voice_cooldown := 0.0
const VOICE_COOLDOWN_TIME := 6.0
signal parrot_flap
signal parrot_screech(word)

@onready var sfx_player = $AudioStreamPlayer

@export var cat_wakeup_voice: Array[AudioStream] = []
@export var cat_cought_react: Array[AudioStream] = []
@export var cat_jump_voice: Array[AudioStream] = []
@export var cat_sleep_voice: Array[AudioStream] = []

	
func _ready() -> void:
	state = CAT_STATES.sleep
	$AnimatedSprite2D.play("sleep")
	var root = get_tree().root.get_child(1)
	root.connect("parrot_screech",hear_sound)
	root.connect("parrot_flap",_parrot_flap)
	
	print(root.get_child(1))
	#level.connect("emit_sound",hear_sound)


func _parrot_screech(word):
	print("cat recognise screech")
	
func _parrot_flap():
	print("cat parrot flap")
func _physics_process(delta: float) -> void:
	if voice_cooldown > 0.0:
		voice_cooldown -= delta
	player_pos = player_data.player_position
	if(state == CAT_STATES.sleep):
		state_sleep()
	if(state == CAT_STATES.walk):
		state_walk()
	if(state == CAT_STATES.jump):
		state_jump()
	if(state == CAT_STATES.dead):
		state_dead()
		queue_free()
	yspd+=grav
	position.y+=yspd
	move_and_slide()
	

func state_sleep() -> void:
	if voice_cooldown <= 0.0: 
		var random_sfx = cat_sleep_voice[0]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME  # Reset cooldown

	if(player_pos.distance_to(position) < awake_dis):
		dir = -sign(position.x - player_pos.x) 
		jump()
	
func state_walk() -> void:
	if voice_cooldown <= 0.0: 
		var random_sfx = cat_jump_voice[2]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME 
	#walk
	position.x += dir * spd
	yspd = 0
	grav=0.2
	position.y += grav*4
	#jump
	if(!grounded):
		jump()
		
	
func state_jump() -> void:
	#fall
	position.x += dir * spd*5
	grav=0.2
	grounded=false
	yspd += grav
	position.y += yspd
	if(grounded): state = CAT_STATES.dead
	
func state_dead() -> void:
	#make sure the cat doesnt have a hitbox here
	pass
	

func jump() -> void:
	yspd -= jumpforce*2
	state = CAT_STATES.jump
	$AnimatedSprite2D.play("jump")
	var random_sfx = cat_jump_voice[randi() % cat_jump_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
	voice_cooldown = VOICE_COOLDOWN_TIME 
	moving_left=position.x>player_pos.x
	if moving_left:
		$AnimatedSprite2D.flip_h=false
	else:
		$AnimatedSprite2D.flip_h=true
		
	
func hear_sound(voice) -> void:
	grav=0.2
	dir = -sign(position.x - player_pos.x)
	var random_sfx = cat_wakeup_voice[randi() % cat_wakeup_voice.size()]
	sfx_player.stream = random_sfx
	sfx_player.play()
	voice_cooldown = VOICE_COOLDOWN_TIME 
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
	else:
		$AnimatedSprite2D.flip_h=true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("platforms"):
		grav=0
		grounded=true
	if area.is_in_group("parrot"):
		var random_sfx = cat_cought_react[randi() % cat_cought_react.size()]
		sfx_player.stream = random_sfx
		sfx_player.play()
		voice_cooldown = VOICE_COOLDOWN_TIME 
		


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("platforms"):
		grounded=false
