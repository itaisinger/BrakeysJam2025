extends CanvasLayer
var coins=0
var coins_max = 7

@onready var death
@onready var win



func _ready():
	var root = get_tree().root.get_child(1)
	#root.connect("add_coin",_add_coin)

func set_keys(n):
	coins = n
	$Label.text=str(coins) + "/" + str(coins_max)

func death_screen():
	var tween = create_tween()
	tween.tween_property($deathImage, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_SINE).set_custom_interpolator(inter)

func win_screen():
	var tween = create_tween()
	tween.tween_property($winImage, "modulate:a", 1.0, 3).set_trans(Tween.TRANS_SINE).set_custom_interpolator(inter)

	
	
func inter(x):
	return min(0.8, pow(x,3))
	
