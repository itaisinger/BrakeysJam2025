extends Camera2D

@onready var player = %Parot
@onready var target = %camera_target
@export var xoff : float = 100
@export var off_spd : float = 0.01
var current_offset = 0

func _process(delta: float) -> void:
	current_offset = lerp(float(current_offset),xoff * player.xspd,off_spd)
	target.position = player.position + Vector2(current_offset,0)
	
	
	#offset.x = lerp(offset.x,xoff  * player.xspd,off_spd)
	pass

#func lerp(start: float,end: float,spd:float):
	#return start + (end-start)*spd
