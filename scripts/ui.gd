extends CanvasLayer


class_name UI


@onready var lives_label: Label = %LivesLabel
@onready var score_label: Label = %ScoreLabel
@onready var game_over_container = %GameOverContainer
@onready var level_complete_container = %LevelCompleteContainer

# TO DELETE
func set_lives(lives: int):
	lives_label.text = "Lives: %d" % lives

# TO DELETE
func set_score(score: int):
	score_label.text = "Score: %d" % score


func game_over():
	game_over_container.show()
	

func level_completed():
	level_complete_container.show()

# BUTTONS
func _on_restart_button_pressed():
	get_tree().reload_current_scene()


func _on_menu_button_pressed():
	pass # Replace with function body.


func _on_retry_button_pressed():
	get_tree().reload_current_scene()


func _on_next_button_pressed():
	pass # Replace with function body.
