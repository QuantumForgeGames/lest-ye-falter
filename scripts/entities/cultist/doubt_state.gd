extends State

@export var DISSENT_CONVERSION_CHANCE: float = 0.05
@export var SERVER_CONVERSION_CHANCE: float = 0.2

@export var SERVER_CONVERSION_CHANCE_ON_HIT: float = 0.5

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
	if randf() < SERVER_CONVERSION_CHANCE_ON_HIT:
		if not EventManager.minigame_active:
			EventManager.on_minigame_started()
			transitioned.emit("Server")
	else:
		EventManager.cultist_killed.emit(entity)

func _on_doubt_timer_timeout() -> void:
	var prob :=  randf()
	if prob < DISSENT_CONVERSION_CHANCE:
		transitioned.emit("Dissent")
	elif prob < DISSENT_CONVERSION_CHANCE + SERVER_CONVERSION_CHANCE:
		if not EventManager.minigame_active:
			EventManager.on_minigame_started()
			transitioned.emit("Server")
	else:
		entity.doubt_timer.start()
