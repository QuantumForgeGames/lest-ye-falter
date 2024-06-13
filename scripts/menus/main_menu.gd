extends Control


func _on_play_button_pressed():
	SceneTransition.change_scene("res://scenes/menus/instructions.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
