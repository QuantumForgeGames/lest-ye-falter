extends Node

signal cultist_captured(cultist: Cultist)
signal cultist_convinced(cultist: Cultist)
signal cultist_killed(cultist: Cultist)
signal cultist_escaped(cultist: Cultist)

signal cultist_state_changed(cultist: Cultist)

signal level_lost()
signal level_won()

var minigame_active: bool = false

func on_minigame_started() -> void:
	minigame_active = true

func on_minigame_completed() -> void:
	if minigame_active:
		get_tree().create_timer(6.).timeout.connect(func(): minigame_active = false)
