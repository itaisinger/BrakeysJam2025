extends Node2D
var win = false
var trans_prec = 0

func draw_win_screen():
	win = true
	
func _draw():
	if(win):
		var col = Color.BLACK
		var screen_w = 1280
		var screen_h = 720
		
		#sides
		var left = screen_w * trans_prec * 0.5
		var right = left + screen_w/2
		var top = screen_h * trans_prec * 0.5
		var bottom = top + screen_h/2
		
		var rect
		
		#top
		draw_rect(Rect2(Vector2(left,0), Vector2(right,top)) ,col)
		#bottom
		draw_rect(Rect2(Vector2(left,bottom), Vector2(right,screen_h)) ,col)
		#left
		draw_rect(Rect2(Vector2(0,0), Vector2(left,screen_h)) ,col)	
		#right
		draw_rect(Rect2(Vector2(right,0), Vector2(right,screen_h)) ,col)
