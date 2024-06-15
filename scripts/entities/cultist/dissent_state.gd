extends State

var DELAY_MIN: float = 0.5
var DELAY_MAX: float = 1.
var CONVERSION_CHANCE: float = 0.1

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)
	
	entity.change_sprite(Cultist.STATES.DISSENT)
	entity.set_collision_layer_value(2, false) # exclude from AoI
	_on_dissent_timer_timeout()

func exit() -> void:
	entity.set_collision_layer_value(2, true) # include in AoI
	entity.dissent_timer.stop()

func on_hit() -> void:
	EventManager.cultist_killed.emit(entity)

func _on_dissent_timer_timeout() -> void:
	entity.dissent_timer.start(randf_range(DELAY_MIN, DELAY_MAX))
	
	var neighbours = entity.area_of_influence.get_overlapping_bodies()
	if neighbours.size() == 0: return # if no infectable neighbours, do nothing
	
	# alter probability logic to take into account the number of neighbours
	if randf() < CONVERSION_CHANCE:
		neighbours.pick_random().set_state(Cultist.STATES.DOUBT)
