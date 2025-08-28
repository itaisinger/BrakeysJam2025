extends CanvasLayer
var coins=0
func _ready():
	var root = get_tree().root.get_child(1)
	#root.connect("add_coin",_add_coin)

func add_key():
	coins+=1
	$Label.text=str(coins)

func death_screan():
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
