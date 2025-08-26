extends Node

var layers = []
var spds = []
var screen_w = 480

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layers.append($Layer1)
	layers.append($Layer2)
	layers.append($Layer3)
	layers.append($Layer4)
	layers.append($Layer5)
	layers.append($Layer6)
	
	for i in layers.size():
		spds.append((i + 1) * 0.6)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in layers.size():
		layers[i].position.x += spds[i]
		if(layers[i].position.x >= screen_w/2):
			layers[i].position.x -= screen_w
	pass
