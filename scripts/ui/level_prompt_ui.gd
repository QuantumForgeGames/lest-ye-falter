extends CanvasLayer

@onready var game_over_container = %GameOverContainer
@onready var level_complete_container = %LevelCompleteContainer

func _ready() -> void:
	EventManager.level_won.connect(_on_level_won)
	EventManager.level_lost.connect(_on_level_lost)

func _on_level_lost():
	game_over_container.show()
	var tween := get_tree().create_tween()
	tween.tween_property(game_over_container, "modulate:a", 1., 1.)
	tween.tween_callback(func(): get_tree().root.get_child(-1).process_mode = Node.PROCESS_MODE_DISABLED)
	
func _on_level_won():
	level_complete_container.show()
	var tween := get_tree().create_tween()
	tween.tween_property(level_complete_container, "modulate:a", 1., 1.)
	tween.tween_callback(func(): get_tree().root.get_child(-1).process_mode = Node.PROCESS_MODE_DISABLED)

# BUTTONS
func _on_restart_button_pressed():
	LevelManager.reload_scene()
	_fade_panels()
	
func _on_menu_button_pressed():
	_fade_panels()
	LevelManager.change_level("LVL1") # ??
	
func _on_retry_button_pressed():
	LevelManager.reload_scene()
	_fade_panels()

func _on_next_button_pressed():
	LevelManager.reload_scene()
	#LevelManager.change_level(2)
	_fade_panels()

func _fade_panels() -> void:
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(level_complete_container, "modulate:a", 0., 1.)
	tween.tween_property(game_over_container, "modulate:a", 0., 1.)

func _hide_panels() -> void:
	game_over_container.hide()
	level_complete_container.hide()	
