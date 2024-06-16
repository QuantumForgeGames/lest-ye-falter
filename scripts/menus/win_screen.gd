extends Control

@onready var _BackButton :TextureButton = $BackButton


func _ready () -> void:
	_BackButton.mouse_entered.connect(func(): _BackButton.scale = Vector2(1.1, 1.1))
	_BackButton.mouse_exited.connect(func(): _BackButton.scale = Vector2(1., 1.))
	_BackButton.pressed.connect(func(): LevelManager.change_scene("MAIN_MENU"))
