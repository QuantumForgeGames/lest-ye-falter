extends Control

@onready var _BackButton :TextureButton = $BackButton
@onready var _NewGamePlusButton :Button = $NewGamePlusButton


func _ready () -> void:
    _BackButton.mouse_entered.connect(func(): _BackButton.scale = Vector2(1.1, 1.1))
    _BackButton.mouse_exited.connect(func(): _BackButton.scale = Vector2(1., 1.))
    _BackButton.pressed.connect(func(): LevelManager.change_scene("MAIN_MENU"))

    if LevelManager.is_new_game_plus: _NewGamePlusButton.visible = false
    _NewGamePlusButton.mouse_entered.connect(func(): _NewGamePlusButton.scale = Vector2(1.1, 1.1))
    _NewGamePlusButton.mouse_exited.connect(func(): _NewGamePlusButton.scale = Vector2(1., 1.))
    _NewGamePlusButton.pressed.connect(func(): LevelManager.change_scene("LVL5"))
