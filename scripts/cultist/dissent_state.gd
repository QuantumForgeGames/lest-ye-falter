extends State

@export var DELAY_MIN: float = 0.5
@export var DELAY_MAX: float = 1.
@export var CONVERSION_CHANCE: float = 0.1

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)
	
	entity.change_sprite(Cultist.STATES.DISSENT)
	entity.set_collision_layer_value(2, false) # exclude from AoI
	_on_doubt_timer_timeout()

func exit() -> void:
	entity.set_collision_layer_value(2, true) # include to AoI
	entity.doubt_timer.stop()

func on_hit() -> void:
	entity.exit_scene()

func _on_doubt_timer_timeout() -> void:
	var neighbours = entity.area_of_influence.get_overlapping_bodies()
	if randf() < CONVERSION_CHANCE:
		neighbours.pick_random().set_state(Cultist.STATES.DOUBT)
	
	entity.doubt_timer.start(randf_range(DELAY_MIN, DELAY_MAX))
