extends Node

@export var minigame_ui_scene: PackedScene
var minigame_ui = null

enum GLYPHS {UP, DOWN, LEFT, RIGHT}
var glyph_textures = [preload("res://assets/art/minigame/arrowUp.png"), preload("res://assets/art/minigame/arrowDown.png"), preload("res://assets/art/minigame/arrowLeft.png"), preload("res://assets/art/minigame/arrowRight.png")]

var combination: Array[GLYPHS]
var target_cultist: Cultist = null
var tween: Tween = null

@export var paddle: Paddle

func _ready() -> void:
	EventManager.cultist_captured.connect(_on_cultist_captured)
	process_mode = Node.PROCESS_MODE_DISABLED
	
func _process(_delta: float) -> void:
	if combination.size() == 0:
		EventManager.cultist_convinced.emit(target_cultist)
		AudioManager.play_stream_oneshot(AudioManager.audio_minigame_win)
		_terminate_minigame()
		
	if Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right") or Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
		if (Input.is_action_just_pressed("move_left") and combination[0] == GLYPHS.LEFT
		or Input.is_action_just_pressed("move_right") and combination[0] == GLYPHS.RIGHT
		or Input.is_action_just_pressed("move_up") and combination[0] == GLYPHS.UP
		or Input.is_action_just_pressed("move_down") and combination[0] == GLYPHS.DOWN):
			var idx = 4 - combination.size()
			_highlight_glyph(idx, 1)
			if idx < 3: AudioManager.play_stream_oneshot(AudioManager.audio_minigame_notes.pick_random())
			else: AudioManager.play_stream_oneshot(AudioManager.audio_minigame_win)
			combination.remove_at(0)
		else:
			EventManager.cultist_escaped.emit(target_cultist)
			target_cultist.exit_scene()
			_highlight_glyph(4 - combination.size(), 0)
			AudioManager.play_stream_oneshot(AudioManager.audio_minigame_lose)
			_terminate_minigame()

func _on_cultist_captured(cultist: Cultist):
	target_cultist = cultist
	combination = [GLYPHS.values().pick_random(),  GLYPHS.values().pick_random(),  GLYPHS.values().pick_random(),  GLYPHS.values().pick_random()]
	
	minigame_ui = minigame_ui_scene.instantiate()
	minigame_ui.z_index = 2
	minigame_ui.position = paddle.global_position + Vector2(160, -100)
	
	for idx in combination.size():
		minigame_ui.get_node("Glyphs").get_child(idx).texture = glyph_textures[combination[idx]]
	
	add_child(minigame_ui)
	
	# visuals
	tween = get_tree().create_tween()
	tween.tween_property(minigame_ui, "modulate:a", 1., 0.25)
	
	for glyph in minigame_ui.get_node("Glyphs").get_children():
		tween.tween_property(glyph, "modulate:a", 1., 0.1)
		
	tween.tween_callback(_start_minigame)

func _start_minigame():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _terminate_minigame():
	target_cultist = null
	process_mode = PROCESS_MODE_DISABLED
	if tween: await tween.finished
	if minigame_ui:
		tween = get_tree().create_tween()
		tween.tween_property(minigame_ui, "modulate:a", 0., 0.5)
		tween.tween_callback(minigame_ui.queue_free)
		EventManager.on_minigame_completed()

func _highlight_glyph(idx: int, code: int):
	if is_instance_valid(minigame_ui):
		var glyph = minigame_ui.get_node("Glyphs").get_child(idx)
		
		tween = get_tree().create_tween()
		tween.tween_property(glyph, "scale", Vector2(0.68, 0.68), 0.2)
		tween.tween_property(glyph, "scale", Vector2(0.34, 0.34), 0.2)
		
		if code == 1: 
			#glyph.modulate = Color8(112, 180, 71)
			glyph.modulate = Color8(85, 131, 0)
		else:
			#glyph.modulate = Color8(232, 63, 54)
			glyph.modulate = Color8(175, 0, 0)
