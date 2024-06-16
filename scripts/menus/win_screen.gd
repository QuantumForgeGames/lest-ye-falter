extends Control

@onready var _BackButton :TextureButton = $BackButton
@onready var _NewGamePlusButton :TextureButton = $NewGamePlusButton


func _ready () -> void:
	_BackButton.mouse_entered.connect(func():
		AudioManager.play_stream_oneshot(AudioManager.audio_misc_hover)
		_BackButton.scale = Vector2(1.1, 1.1)
	)
	_BackButton.mouse_exited.connect(func(): _BackButton.scale = Vector2(1., 1.))
	_BackButton.pressed.connect(func():
		AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
		LevelManager.change_scene("MAIN_MENU")
	)


	if LevelManager.is_new_game_plus: _NewGamePlusButton.visible = false
	_NewGamePlusButton.mouse_entered.connect(func():
		AudioManager.play_stream_oneshot(AudioManager.audio_misc_hover)
		_NewGamePlusButton.scale = Vector2(1.1, 1.1)
	)
	_NewGamePlusButton.mouse_exited.connect(func(): _NewGamePlusButton.scale = Vector2(1., 1.))
	_NewGamePlusButton.pressed.connect(func():
		AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
		LevelManager.change_scene("LVL5")
	)
	
	var tween = self.create_tween()
	for label in $Dialogue.get_children():
		tween.tween_property(label, "modulate:a", 1, 1.0).set_delay(1.5)
		
