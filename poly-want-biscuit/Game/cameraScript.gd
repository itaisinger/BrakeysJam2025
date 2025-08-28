extends Camera2D

@onready var player = %Parot
@export var xoff : float = 100
@export var off_spd : float = 0.01

func _process(delta: float) -> void:
	offset.x = lerp(offset.x,xoff * player.dir,off_spd)
	pass
	
func lerp(start,end,spd):
	return start + (end-start)*spd
