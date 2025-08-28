extends CanvasLayer
var coins=0
var coins_max = 7
func _ready():
	var root = get_tree().root.get_child(1)
	#root.connect("add_coin",_add_coin)

func set_keys(n):
	coins = n
	$Label.text=str(coins) + "/" + str(coins_max)

func death_screen():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
