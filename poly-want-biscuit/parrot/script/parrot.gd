extends CharacterBody2D
enum State { IDLE, LEFT, RIGHT }
enum Status {JUMPING,FLYING}
var current_state=State.IDLE
var current_status=Status.FLYING
var grounded=false
var yspd=0
var grav=0.2
var jumpforce=7
var xspd = 0
var xacc = 8
var x_spd_min = 2.5
var x_spd_max = 10
var xfric = 1.8


func _ready() -> void:
	print("I'm ready!")

func _physics_process(delta: float) -> void:
	print(xspd)
	grounded = position.y > 200
	if(!grounded):
		yspd+=grav
	else:
		yspd = 0
	if current_status==Status.JUMPING:
		yspd = -jumpforce
		current_status=Status.FLYING
	if current_status==Status.FLYING:
		pass
	else:
		var tween := create_tween()
		tween.tween_property(self, "position:y", position.y - 70, 0.4) 
		current_status=Status.FLYING
	if (current_state==State.IDLE):
		pass
	elif (current_state==State.RIGHT):
		$AnimatedSprite2D.flip_h=true
		if Input.is_action_pressed("Look_Right"):
			xspd = xacc
		else: xspd = xfric
	else :
		$AnimatedSprite2D.flip_h=false
		if Input.is_action_pressed("Look_Left"):
			xspd = -xacc
		else: xspd = -xfric
	if(grounded):
		xspd = 0
	position.x += xspd
	position.y+=yspd

func _process(delta):
	if Input.is_action_pressed("Look_Left") and Input.is_action_pressed("Look_Right"):
		current_state=State.IDLE
	elif Input.is_action_pressed("Look_Left"):
		current_state=State.LEFT
	elif  Input.is_action_pressed("Look_Right"):
		current_state=State.RIGHT
	
	if Input.is_action_just_pressed("Jump"):
		current_status=Status.JUMPING
		grounded=false
		print("jumpinh")
	
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		grounded=true
