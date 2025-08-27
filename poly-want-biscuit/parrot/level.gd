extends Node2D
signal parrot_screech(word)
signal parrot_flap
func _ready():
	$parrot.connect("parrot_flap",_parrot_flap)
	$parrot.connect("parrot_screech",_parrot_screech)

func _parrot_flap():
	emit_signal("parrot_flap")
	#print("flap")

func _parrot_screech(word):
	emit_signal("parrot_screech",word)
	#print("screech")
