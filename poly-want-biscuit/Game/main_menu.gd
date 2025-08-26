extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	#get_tree().change_scene("res://Game/game.tscn")
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
