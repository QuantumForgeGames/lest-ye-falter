extends Node

var minigame_ui_scene := preload("res://scenes/ui/minigame_ui.tscn")
var minigame_ui = null

enum GLYPHS {UP, DOWN, LEFT, RIGHT}
var combination = [GLYPHS.DOWN, GLYPHS.UP, GLYPHS.LEFT, GLYPHS.RIGHT]

@export var paddle: Paddle

func _ready() -> void:
	EventManager.cultist_captured.connect(_on_cultist_captured)
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(delta: float) -> void:
	if combination.size() == 0:
		EventManager.cultist_converted.emit()
		_terminate_minigame()
		
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		if (Input.is_action_just_pressed("move_left") and combination[0] == GLYPHS.LEFT
		or Input.is_action_just_pressed("move_right") and combination[0] == GLYPHS.RIGHT
		or Input.is_action_just_pressed("move_up") and combination[0] == GLYPHS.UP
		or Input.is_action_just_pressed("move_down") and combination[0] == GLYPHS.DOWN):
			combination.remove_at(0)
		else:
			EventManager.cultist_killed.emit()
			_terminate_minigame()

func _on_cultist_captured(cultist: Cultist):
	# generate random
	var combination = [GLYPHS.DOWN, GLYPHS.UP, GLYPHS.LEFT, GLYPHS.RIGHT]
	process_mode = Node.PROCESS_MODE_ALWAYS
	minigame_ui = minigame_ui_scene.instantiate()
	minigame_ui.position = paddle.global_position + Vector2(0, -200) - paddle.half_paddle_width * Vector2(1, 0)
	add_child(minigame_ui)

func _terminate_minigame():
	process_mode = PROCESS_MODE_DISABLED
	minigame_ui.queue_free()
