extends CharacterBody2D
enum State { IDLE, LEFT, RIGHT }
enum Status {JUMPING,FLYING}
var current_state=State.LEFT
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
var screech_visible=false
signal parrot_flap
signal parrot_screech(word)



func _ready() -> void:
	print("I'm ready!")

func _physics_process(delta: float) -> void:
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
	move_and_slide()
	player_data.player_position = global_position

func _process(delta):
	if Input.is_action_pressed("Look_Left") and Input.is_action_pressed("Look_Right"):
		current_state=State.IDLE
	elif Input.is_action_pressed("Look_Left"):
		current_state=State.LEFT
		$Sprite2D.position=Vector2(-100,0)
		$Sprite2D.flip_v=false
	elif  Input.is_action_pressed("Look_Right"):
		current_state=State.RIGHT
		$Sprite2D.position=Vector2(100,0)
		$Sprite2D.flip_v=true
	
	if Input.is_action_just_pressed("Jump"):
		emit_signal("parrot_flap")
		current_status=Status.JUMPING
		grounded=false
		match current_state:
			"LEFT":
				xspd=xfric
			"RIGHT":
				xspd=-xfric
	
	if Input.is_action_just_pressed("Screech"):
		emit_signal("parrot_screech",Globals.VOICES.meow)
		$Sprite2D.visible=true
		for i in range(11):
			await get_tree().create_timer(0.1).timeout
			$Sprite2D.visible=screech_visible
			screech_visible=!screech_visible
		$Sprite2D.visible=false



func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("platforms"):
		grounded=true
		xspd=0
