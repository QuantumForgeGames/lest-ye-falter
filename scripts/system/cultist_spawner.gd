extends Node2D
class_name CultistSpawner

@export var cultist_scene: PackedScene

func _ready() -> void:
	# debug stuff
	var xmax = get_viewport_rect().size.x
	var ymax = get_viewport_rect().size.y
	var xbuffer: float = 250.
	var spacing: float = 100.
	
	for x in range(xbuffer, xmax - xbuffer, spacing):
		for y in range(xbuffer, ymax - 2.5 * xbuffer, spacing):
			var cultist := cultist_scene.instantiate()
			cultist.global_position = Vector2(x, y)
			add_child(cultist)
			#cultist.set_state(Cultist.STATES.DOUBT)

	get_child(5).set_state(Cultist.STATES.DISSENT)
	get_child(21).set_state(Cultist.STATES.DISSENT)
