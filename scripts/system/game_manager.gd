extends Node
class_name GameManager

@export var cultist_spawner: CultistSpawner

# stats for computing score at the end
var num_base_killed: int = 0
var num_doubt_killed: int = 0
var num_dissent_killed: int = 0

var num_escaped: int = 0
var num_converted: int = 0

# live counter during game
var num_base: int = 0
var num_doubt: int = 0
var num_dissent: int = 0

var level_active: bool = false

func _ready() -> void:
	LevelPrompt._hide_panels()
	
	EventManager.cultist_convinced.connect(_on_cultist_convinced)
	EventManager.cultist_killed.connect(_on_cultist_killed)
	EventManager.cultist_escaped.connect(_on_cultist_escaped)
	
	EventManager.cultist_state_changed.connect(_recompute_stats)
	EventManager.cultist_killed.connect(_recompute_stats)
	EventManager.cultist_escaped.connect(_recompute_stats)
	get_tree().create_timer(5).timeout.connect(func(): level_active = true)
	
func _on_cultist_convinced(cultist: Cultist) -> void:
	cultist.return_to_spawn()
	num_converted += 1

func _on_cultist_killed(cultist: Cultist) -> void:
	match cultist.get_current_state():
		"Base":
			num_base_killed += 1
		"Doubt":
			num_doubt_killed += 1
		"Dissent":
			num_dissent_killed += 1
		"Server":
			num_doubt_killed += 1
			
	cultist.exit_scene()
	cultist.reparent(get_parent())

func _on_cultist_escaped(cultist: Cultist) -> void:
	num_escaped += 1
	cultist.reparent(get_parent())

func _recompute_stats(_cultist: Cultist) -> void:
	num_base = 0
	num_doubt = 0
	num_dissent = 0

	for cultist in cultist_spawner.get_children():
		match cultist.get_current_state():
			"Base":
				num_base += 1
			"Doubt":
				num_doubt += 1
			"Dissent":
				num_dissent += 1
			"Server":
				num_doubt += 1
	
	if level_active: _check_game_status()

func _check_game_status():
	if float(num_base)/(num_base + num_doubt + num_dissent) < 0.35:
		EventManager.level_lost.emit()
	if num_dissent == 0:
		EventManager.level_won.emit()
