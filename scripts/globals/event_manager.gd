extends Node

signal cultist_captured(cultist: Cultist)
signal cultist_convinced(cultist: Cultist)
signal cultist_killed(cultist: Cultist)
signal cultist_escaped(cultist: Cultist)

signal cultist_state_changed(cultist: Cultist)

signal kick_state_changed(val: float, duration: float)

signal level_lost()
signal level_won()

var minigame_active: bool = false
var delay: float = 6.


func _ready () -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func on_minigame_started(timeout_duration: float) -> void:
	minigame_active = true
	delay = timeout_duration


func on_minigame_completed() -> void:
	if minigame_active:
		get_tree().create_timer(delay).timeout.connect(func(): minigame_active = false)
