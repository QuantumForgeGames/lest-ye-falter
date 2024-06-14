extends Control

func _input(event):
	if event.is_action_pressed("move_right"):
			LevelManager.change_scene("INSTRUCTIONS2")

func _on_page_two_button_mouse_entered() -> void:
	$PageTwoButton.scale = Vector2(1.1, 1.1)

func _on_page_two_button_mouse_exited() -> void:
	$PageTwoButton.scale = Vector2(1, 1)

func _on_page_two_button_pressed() -> void:
	LevelManager.change_scene("INSTRUCTIONS2")
