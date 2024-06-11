extends State

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)

	entity.change_sprite(Cultist.STATES.BASE)

func process(_delta: float) -> void:	
	pass
 
func on_hit() -> void:
	EventManager.cultist_killed.emit(entity)
