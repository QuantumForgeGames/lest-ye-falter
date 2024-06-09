extends State

@export var CONVERSION_CHANCE: float = 0.1

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)
	
	entity.change_sprite(Cultist.STATES.DOUBT)
	entity.set_collision_layer_value(2, false) # exclude from AoI
	entity.doubt_timer.start()

func exit() -> void:
	entity.set_collision_layer_value(2, true) # include in AoI
	entity.doubt_timer.stop()

func process(_delta: float) -> void:	
	pass
 
func on_hit() -> void:
	entity.exit_scene()

func _on_doubt_timer_timeout() -> void:
	if randf() < CONVERSION_CHANCE:
		transitioned.emit("Dissent")
	else:
		entity.doubt_timer.start()
