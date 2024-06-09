extends State

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)
	
	entity.set_collision_layer_value(1, false) # cannot be hit by ball
	entity.set_collision_mask_value(1, false) # cannot hit ball
	entity.set_collision_layer_value(2, false) # exclude from AoI
	entity.velocity = 0.8 * entity.speed * Vector2(0, 1)

func exit() -> void:
	entity.doubt_timer.stop()

func process(_delta: float) -> void:
	entity.move_and_slide()
