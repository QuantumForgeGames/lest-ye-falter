extends Control


func _on_play_button_pressed():
	LevelManager.change_scene("INSTRUCTIONS1")

func _on_quit_button_pressed():
	get_tree().quit()
