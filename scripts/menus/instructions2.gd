extends Control

func _input(event):
	if event.is_action_pressed("move_left"):
			LevelManager.change_scene("INSTRUCTIONS1")
	elif event.is_action_pressed("move_right"):
			LevelManager.change_scene("LVL1")
			
func _on_page_one_button_mouse_entered() -> void:
	$PageOneButton.scale = Vector2(1.1, 1.1)

func _on_page_one_button_mouse_exited() -> void:
	$PageOneButton.scale = Vector2(1, 1)

func _on_page_one_button_pressed() -> void:
	LevelManager.change_scene("INSTRUCTIONS1")

func _on_start_button_mouse_entered() -> void:
	$PageOneButton.scale = Vector2(1.1, 1.1)

func _on_start_button_mouse_exited() -> void:
	$PageOneButton.scale = Vector2(1, 1)

func _on_start_button_pressed() -> void:
	LevelManager.change_scene("LVL1")
