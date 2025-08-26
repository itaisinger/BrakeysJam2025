extends Control
class_name main_menu

func _ready() -> void:
	$VBoxContainer/StartButton.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://parrot/level/level.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
