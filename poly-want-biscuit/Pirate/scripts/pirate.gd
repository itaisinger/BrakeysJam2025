extends Node2D
class_name pirate


#prob git mess:
enum _Pirate_Type {
	Cat_lover,
	Cat_hater
}

enum _States {
	Idle,
	Roam,
	React,
	Chase
}
var _current_state = null
var _timer := 0.5
var _direction = 1
const SPEED := 60
var dir=0
var hear_distance= 400
var screechable=true

#recreated by itai, maybe was lost due to github mess:
var _pirate_type = _Pirate_Type.Cat_lover

#@onready var parent: CharacterBody2D = get_parent()
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	var root = get_tree().root.get_child(1)
	root.connect("parrot_screech",hear_sound)


func hear_sound(voice) -> void:
	if position.distance_to(player_data.player_position)>hear_distance or !screechable:
		pass
	else:
		screechable=false
		$Timer.start(6)
		_direction = sign(position.x - player_data.player_position.x)
		#var random_sfx = cat_wakeup_voice[randi() % cat_wakeup_voice.size()]
		#sfx_player.stream = random_sfx
		#sfx_player.play()
		#voice_cooldown = VOICE_COOLDOWN_TIME 
		if(voice == Globals.VOICES.meow):
			#play happy meow sound
			_current_state=_States.Roam
			#dir = towards pos
		if(voice == Globals.VOICES.curse):
			#play angry meow sound
			_current_state=_States.Roam
			_direction = -_direction
		if _direction>0:
			$AnimatedSprite2D.flip_h=false
		else:
			$AnimatedSprite2D.flip_h=true

func _process(delta: float) -> void:
	_timer -= delta
	match _current_state:
		_States.Idle:
			_IdleState(delta)
		_States.Roam:
			_RoamState(delta)
		_States.React:
			_ReactState(delta)
		_States.Chase:
			_ChaseState(delta)
		



func _IdleState(delta):
	#animation/spirte change
	if _timer <= 0.0 :
		_timer = randi_range(3,7)
		_direction = [1, -1][randi() % 2]
		if _direction < 0 :
			sprite.flip_h = true
		else :
			sprite.flip_h = false
		_current_state = _States.Roam	

func _RoamState(delta):
	if ray_cast_right.is_colliding():
		_direction = -1
		sprite.flip_h = true
	if ray_cast_left.is_colliding():
		_direction = 1
		sprite.flip_h = false
	position.x += _direction* SPEED * delta
	if _timer <= 0.0: 
		_timer = randi_range(3,7)
		_current_state = _States.Idle


func _ReactState(delta):
	if ray_cast_right.is_colliding():
		_direction = -1
		sprite.flip_h = true
	if ray_cast_left.is_colliding():
		_direction = 1
		sprite.flip_h = false
	position.x += _direction* SPEED * delta
	if _timer <= 0.0: 
		_timer = randi_range(3,7)
		_current_state = _States.Idle
	
func _ChaseState(delta):
	var direction_x =  player_data.player_position.x - position.x
	var new_velocity = Vector2(direction_x, 0).normalized() * SPEED * delta
	position.x+=new_velocity.x
	#parent.velocity = new_velocity
	if ray_cast_right.is_colliding() or ray_cast_left.is_colliding():
		_current_state = _States.Roam
	if _timer <= 0.0: 
		_timer = randi_range(3,7)
		_current_state = _States.Idle
	
	

func _on_follow_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		_timer = 5
		_current_state = _States.Chase
		


func _on_follow_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("parrot"):
		_timer = 5
		_current_state = _States.Chase
		print("found YErr lazy parot")
		#play_random_voice()

#func play_random_voice():
	#if _pirate_type == _Pirate_Type.Cat_hater: 
		#if bad_pirate_voice.size() > 0:
			#var random_sfx = bad_pirate_voice[randi() % bad_pirate_voice.size()]
			#sfx_player.stream = random_sfx
			#sfx_player.play()

#git mess:
#func play_random_voice():
	#if _pirate_type == _Pirate_Type.Cat_hater:
		#if bad_pirate_voice.size() > 0:
			#var random_sfx = bad_pirate_voice[randi() % bad_pirate_voice.size()]
			#sfx_player.stream = random_sfx
			#sfx_player.play()


func _on_timer_timeout() -> void:
	screechable=true
