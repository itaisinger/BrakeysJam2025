extends Node2D
signal parrot_screech(word)
signal parrot_flap
signal key_pickedup
func _ready():
	$Parot.connect("parrot_flap",_parrot_flap)
	$Parot.connect("parrot_screech",_parrot_screech)
	for key in $PickUps.get_children():
		key.connect("key_pickedup",_key_pickedup)

func _parrot_flap():
	emit_signal("parrot_flap")
	#print("flap")

func _parrot_screech(word):
	emit_signal("parrot_screech",word)
	#print("screech")

func _key_pickedup():
	emit_signal("key_pickedup")
