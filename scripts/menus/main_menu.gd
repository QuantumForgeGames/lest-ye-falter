extends Control

var tween: Tween = null

func _on_play_button_pressed():
	LevelManager.change_scene("INSTRUCTIONS1")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_mouse_entered() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($ScreenHover, "modulate:a", 1., 0.5)

func _on_start_button_mouse_exited() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($ScreenHover, "modulate:a", 0., 0.5)

func _on_start_button_pressed() -> void:
	LevelManager.change_scene("INSTRUCTIONS1")
