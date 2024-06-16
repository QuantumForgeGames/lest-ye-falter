extends Control

var tween: Tween = null

var button_hover_audio :AudioStreamPlayer


func _on_play_button_pressed():
	LevelManager.change_scene("INSTRUCTIONS1")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_mouse_entered() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($ScreenHover, "modulate:a", 1., 0.5)
	button_hover_audio = AudioManager.play_stream_oneshot(AudioManager.audio_play_hover)

func _on_start_button_mouse_exited() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property($ScreenHover, "modulate:a", 0., 0.5)
	if button_hover_audio: button_hover_audio.queue_free()

func _on_start_button_pressed() -> void:
	LevelManager.change_scene("INSTRUCTIONS1")
	AudioManager.play_stream_oneshot(AudioManager.audio_play_press)
