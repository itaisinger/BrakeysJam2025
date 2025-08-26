extends Node2D

var grav = 0.8
var yspd = 0
var ground = false
var jump = false
var jumpforce = 5

func _physics_process(delta: float) -> void:
	if(!ground):
		yspd += grav
	
	if(jump):
		yspd -= jumpforce
		
	position.y += yspd
