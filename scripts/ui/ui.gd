extends CanvasLayer
class_name UI

@onready var game_over_container = %GameOverContainer
@onready var level_complete_container = %LevelCompleteContainer

func _ready() -> void:
	EventManager.level_won.connect(_on_level_won)
	EventManager.level_lost.connect(_on_level_lost)

func _on_level_lost():
	game_over_container.show()
	
func _on_level_won():
	level_complete_container.show()

# BUTTONS
func _on_restart_button_pressed():
	LevelManager.reload_scene()

func _on_menu_button_pressed():
	pass
	
func _on_retry_button_pressed():
	LevelManager.reload_scene()

func _on_next_button_pressed():
	LevelManager.reload_scene()
	#	LevelManager.change_level(2)
