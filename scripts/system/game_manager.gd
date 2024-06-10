extends Node
class_name GameManager

func _ready() -> void:
	EventManager.cultist_converted.connect(_on_cultist_converted)
	EventManager.cultist_killed.connect(_on_cultist_killed)
	
func _on_cultist_converted(cultist: Cultist):
	cultist.return_to_spawn()

func _on_cultist_killed(cultist: Cultist):
	cultist.exit_scene()
