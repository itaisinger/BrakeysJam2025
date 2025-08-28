extends CanvasLayer
var coins=0
var coins_max = 7

@onready var death
@onready var win
@onready var drawer = $drawer

var trans_prec = 0

func _ready():
	var root = get_tree().root.get_child(1)
	#root.connect("add_coin",_add_coin)

func _process(delta: float) -> void:
	trans_prec = min(trans_prec+delta,1)

func set_keys(n):
	coins = n
	$Label.text=str(coins) + "/" + str(coins_max)

func death_screen():
	var tween = create_tween()
	tween.tween_property($deathImage, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_SINE).set_custom_interpolator(inter)

func win_screen():
	drawer.draw_win_screen()
	pass
	
func inter(x):
	return min(0.8, pow(x,3))
	
