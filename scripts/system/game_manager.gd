extends Node
class_name GameManager

var num_base_killed: int = 0
var num_doubt_killed: int = 0
var num_dissent_killed: int = 0

var num_escaped: int = 0
var num_converted: int = 0

func _ready() -> void:
	EventManager.cultist_converted.connect(_on_cultist_converted)
	EventManager.cultist_killed.connect(_on_cultist_killed)
	EventManager.cultist_escaped.connect(_on_cultist_escaped)

func _on_cultist_converted(cultist: Cultist):
	cultist.return_to_spawn()
	num_converted += 1

func _on_cultist_killed(cultist: Cultist):
	match cultist.get_node("StateMachine").current_state.name:
		"Base":
			num_base_killed += 1
		"Doubt":
			num_doubt_killed += 1
		"Dissent":
			num_dissent_killed += 1
		"Server":
			num_doubt_killed += 1
			
	cultist.exit_scene()

func _on_cultist_escaped(_cultist: Cultist):
	num_escaped += 1
