extends Node
class_name GameManager

func _ready() -> void:
	EventManager.cultist_converted.connect(_on_cultist_converted)
	EventManager.cultist_killed.connect(_on_cultist_killed)
	
func _on_cultist_converted(cultist: Cultist):
	# add life
	var tween = get_tree().create_tween()
	tween.tween_property(cultist, "modulate:a", 0., 0.5)
	tween.tween_callback(cultist.queue_free)
	pass

func _on_cultist_killed(cultist: Cultist):
	cultist.exit_scene()
