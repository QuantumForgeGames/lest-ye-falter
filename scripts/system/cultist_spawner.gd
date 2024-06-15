extends Node2D
class_name CultistSpawner

@export var cultist_scene: PackedScene
@export var debug: bool = true

@export_category("Doubter parameters")
## Time delay before rolling the dice on conversion to dissenter or initiate minigame or remain as is.
@export var CONVERSION_DELAY: float = 10.
## Probability to become a Dissenter
@export_range (0., 1.) var DISSENT_CONVERSION_CHANCE: float = 0.05
## Probability to randomly initiate minigame
@export_range (0., 1.) var SERVER_CONVERSION_CHANCE: float = 0.2
## Probability to initiate minigame on being served punch
@export_range (0., 1.) var SERVER_CONVERSION_CHANCE_ON_HIT: float = 0.5
 
@export_category("Dissenter parameters")
## Lower bound for randomly choosing a time delay before infecting a new neighbour
@export var INFECTION_DELAY_MIN: float = 0.5
## Upper bound for randomly choosing a time delay before infecting a new neighbour
@export var INFECTION_DELAY_MAX: float = 1.
## Probability of infecting a new neighbour upon randomly chosen time-out duration
@export_range (0., 1.) var NEIGHBOUR_CONVERSION_CHANCE: float = 0.1

func _ready() -> void:
	if debug:
		for cultist in get_children():
			cultist.queue_free()
		
		var xmax = get_viewport_rect().size.x
		var ymax = get_viewport_rect().size.y
		var xbuffer: float = 250.
		var spacing: float = 100.
		
		for x in range(xbuffer, xmax - xbuffer, spacing):
			for y in range(xbuffer, ymax - 2.5 * xbuffer, spacing):
				var cultist := cultist_scene.instantiate()
				cultist.global_position = Vector2(x, y)
				cultist.set_infection_parameters(CONVERSION_DELAY, DISSENT_CONVERSION_CHANCE, SERVER_CONVERSION_CHANCE, SERVER_CONVERSION_CHANCE_ON_HIT, INFECTION_DELAY_MIN, INFECTION_DELAY_MAX, NEIGHBOUR_CONVERSION_CHANCE)
				add_child(cultist)
				#cultist.set_state(Cultist.STATES.DOUBT)
				if randf() < 0.05:
					cultist.set_state(Cultist.STATES.DISSENT)

	else:
		for cultist in get_children():
			cultist.set_infection_parameters(CONVERSION_DELAY, DISSENT_CONVERSION_CHANCE, SERVER_CONVERSION_CHANCE, SERVER_CONVERSION_CHANCE_ON_HIT, INFECTION_DELAY_MIN, INFECTION_DELAY_MAX, NEIGHBOUR_CONVERSION_CHANCE)
