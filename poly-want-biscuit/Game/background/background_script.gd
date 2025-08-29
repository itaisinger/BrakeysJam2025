extends Node

var layers = []
var spds = []
var screen_w = 480
@export var size = 1
@export var offset = 0
@export var yoffset = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layers.append($Layer1)
	layers.append($Layer2)
	layers.append($Layer3)
	layers.append($Layer4)
	layers.append($Layer5)
	layers.append($Layer6)
	screen_w *= size
	
	for i in layers.size():
		spds.append((i + 1) * 0.6 * lerp(size,1,1))
		layers[i].scale = Vector2(size,size)
		layers[i].position += Vector2(screen_w * offset,yoffset)
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in layers.size():
		layers[i].position.x += spds[i]
		if(layers[i].position.x >= screen_w * (offset + 0.5)):
			layers[i].position.x -= screen_w
		
	pass
