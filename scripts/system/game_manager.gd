extends Node
class_name GameManager

@export var cultist_spawner: CultistSpawner
@export var doubt_shader :TextureRect
@export var ball: Ball
@export var paranoia_effect_layer: CanvasLayer

@export_category("Ball properties")
## Maximum serves per paddle bounce
@export var MAX_HITS_PER_PADDLE_BOUNCE: int = 2

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
	paranoia_effect_layer.show()
	ball.set_max_hits(MAX_HITS_PER_PADDLE_BOUNCE)
	LevelPrompt._hide_panels()
	EventManager.minigame_active = false
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
	var doubt = float(num_base)/(num_base + num_doubt + num_dissent)
	_tween_doubt_shader(doubt)
	if doubt < 0.15:
		EventManager.level_lost.emit()
	if num_dissent == 0:
		EventManager.level_won.emit()

func _tween_doubt_shader (doubt :float) -> void:
	var cur_doubt = doubt_shader.material.get_shader_parameter("transparency")
	var tween = self.create_tween()
	tween.tween_method(func(d):
		AudioManager._BackgroundMusic.set_volume_db(remap(d, 0.0, 1.0, -40.0, 0.0))
		doubt_shader.material.set_shader_parameter("transparency", d)
		doubt_shader.material.set_shader_parameter("thresholds", PackedFloat32Array(
			[0.6, 0.67, 0.75].map(func(x): return clampf(0.0, x, x *d *2))
		))
	, cur_doubt, 1. -doubt, 0.25)
