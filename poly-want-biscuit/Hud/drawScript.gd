extends Node2D
var win = false
@onready var trans_prec = 0
@onready var camera = %camera
@export var sound : AudioStreamPlayer
#@onready var sound = get_tree().root.get_node("streamer")
var tex
var sound_heared = false

func _ready() -> void:
	queue_redraw()
	tex = load("res://Hud/cutout.png")

func draw_win_screen():
	win = true
	trans_prec = 0;
	
func _process(delta: float) -> void:
	trans_prec = min(1,trans_prec + delta*0.2)
	if(win and trans_prec == 1 and !sound_heared):
		sound.play()
		sound_heared = true 
	queue_redraw()

func f(x):
	return max(0,2*x*x-x)
	
func _draw():
	if(win):
		var prec = f(trans_prec)
		var zoom = 1#camera.zoom.x
		var col = Color.BLACK
		var screen_w = 1*1280/zoom 
		var screen_h = 1*720/zoom
		
		#sides
		var left = screen_w * prec * 0.5
		var right = screen_w - left
		var top = screen_h * prec * 0.5
		var bottom = screen_h - top
		
		
		#adjust for wierd godot system
		var rect
		
		#top
		draw_rect(Rect2(Vector2(left,0), Vector2(right,top)) ,Color.BLACK)
		#bottom
		draw_rect(Rect2(Vector2(left,bottom), Vector2(right,screen_h)) ,Color.BLACK)
		#left
		draw_rect(Rect2(Vector2(0,0), Vector2(left,screen_h)) ,Color.BLACK)	
		#right
		draw_rect(Rect2(Vector2(right,0), Vector2(screen_w,screen_h)) ,Color.BLACK)
		bottom -= top
		right -= left
		#middle
		#draw_texture_rect(tex,Rect2(Vector2(left,top),Vector2(right,bottom)),false)
		#draw_texture(tex,Vector2(left,top),Color.WHITE)
