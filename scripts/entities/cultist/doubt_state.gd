extends State

var DISSENT_CONVERSION_CHANCE: float = 0.05
var SERVER_CONVERSION_CHANCE: float = 0.2

var SERVER_CONVERSION_CHANCE_ON_HIT: float = 0.5
var DELAY: float = 10.

var MINIGAME_TIMEOUT_DURATION_ON_RANDOM: float = 6.
var MINIGAME_TIMEOUT_DURATION_ON_HIT: float = 3.

func enter() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(entity, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(entity, "scale", Vector2(1., 1.), 0.25)
	
	entity.change_sprite(Cultist.STATES.DOUBT)
	entity.set_collision_layer_value(2, false) # exclude from AoI
	entity.doubt_timer.start(DELAY)

func exit() -> void:
	entity.set_collision_layer_value(2, true) # include in AoI
	entity.doubt_timer.stop()

func process(_delta: float) -> void:	
	pass
 
func on_hit() -> void:
	if randf() < SERVER_CONVERSION_CHANCE_ON_HIT and not EventManager.minigame_active:
		EventManager.on_minigame_started(MINIGAME_TIMEOUT_DURATION_ON_HIT)
		transitioned.emit("Server")
	else:
		EventManager.cultist_killed.emit(entity)
		entity.show_sick_emote()

func _on_doubt_timer_timeout() -> void:
	var prob :=  randf()
	if prob < DISSENT_CONVERSION_CHANCE:
		transitioned.emit("Dissent")
	elif prob < DISSENT_CONVERSION_CHANCE + SERVER_CONVERSION_CHANCE:
		if not EventManager.minigame_active:
			EventManager.on_minigame_started(MINIGAME_TIMEOUT_DURATION_ON_RANDOM)
			transitioned.emit("Server")
	else:
		entity.doubt_timer.start(DELAY)
