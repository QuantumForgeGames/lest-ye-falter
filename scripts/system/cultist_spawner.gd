extends Node2D
class_name CultistSpawner

var cultist_scene: PackedScene = preload("res://scenes/cultist.tscn")

func _ready() -> void:
	# debug stuff
	var xmax = get_viewport_rect().size.x
	var ymax = get_viewport_rect().size.y
	var xbuffer: float = 100.
	var spacing: float = 100.
	
	for x in range(xbuffer, xmax - xbuffer, spacing):
		for y in range(xbuffer, ymax - 6 * xbuffer, spacing):
			var cultist := cultist_scene.instantiate()
			add_child(cultist)
			cultist.global_position = Vector2(x, y)

	get_child(5).set_state(Cultist.STATES.DISSENT)
