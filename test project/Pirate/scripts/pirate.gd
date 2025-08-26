extends Node2D
class_name pirate

enum _Pirate_Type {
	Cat_lover,
	Cat_hater
}

enum _States {
	Idle,
	Roam,
	React
}
var _current_state = null
var _timer := 0.0
var _delay := 4.0
var _direction = 1
const SPEED := 60
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var sprite = $Sprite2D

#func _ready() -> void:
	#_current_state = _States.Idle
	#level.connect("emit_sound",hear_sound)
#
#func hear_sound(voice, pos) -> void:
	#if(position.distance_to(pos) > hear_distance):
		#return
	#if(voice == Globals.VOICES.meow):
		##play happy meow sound
		#_current_state = _States.walk
		##dir = towards pos
		#return
	#if(voice == Globals.VOICES.curse):
		##play angry meow sound
		#_current_state = _States.walk
		##dir = away from pos


func _process(delta: float) -> void:
	_timer += delta
	match _current_state:
		_States.Idle:
			_IdleState(delta)
		_States.Roam:
			_RoamState(delta)
		_States.React:
			_ReactState(delta)



func _IdleState(delta):
	#animation/spirte change
	if _timer >= _delay :
		_timer = 0.0
		_delay = randi_range(3,5)
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
	if _timer > _delay: 
		_timer = 0.0
		_delay = randi_range(3,5)
		_current_state = _States.Idle


func _ReactState(delta):
	pass #not yet implemented
	
