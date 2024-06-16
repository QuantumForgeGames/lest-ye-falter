extends CanvasLayer

@onready var game_over_container = %GameOverContainer
@onready var level_complete_container = %LevelCompleteContainer
@onready var innocents_value_label: Label = %InnocentsValueLabel
@onready var doubters_value_label: Label = %DoubtersValueLabel
@onready var total_value_label: Label = %TotalValueLabel
@onready var star_progress = %StarProgress
@onready var darken_rect = %DarkenRect


func _ready() -> void:
	EventManager.level_won.connect(_on_level_won)
	EventManager.level_lost.connect(_on_level_lost)

func _on_level_lost():
	game_over_container.show()
	var tween := get_tree().create_tween()
	tween.tween_property(game_over_container, "modulate:a", 1., 1.)
	tween.tween_property(darken_rect, "modulate:a", 1., 1.)
	tween.tween_callback(func(): get_tree().root.get_child(-1).process_mode = Node.PROCESS_MODE_DISABLED)
	
func _on_level_won():
	var current_level := _get_current_level()
	if current_level > 0:
		level_complete_container.show()
		var tween := get_tree().create_tween()
		tween.tween_property(level_complete_container, "modulate:a", 1., 1.)
		tween.tween_property(darken_rect, "modulate:a", 1., 1.)
		tween.tween_callback(func(): get_tree().root.get_child(-1).process_mode = Node.PROCESS_MODE_DISABLED)
	else:
		print("Non level script calling _on_level_won.")

# SCORING
func _handle_scoring(innocents_number, doubters_number):
	var innocents_penalty: float = -100.0 * innocents_number
	var doubter_penalty: float = -50.0 * doubters_number
	var total: float = -1 * (innocents_penalty + doubter_penalty)
	star_progress.value = (1 - (total / 1000)) * 100
	innocents_value_label.text = "-100pts x " + str(innocents_number) + " = " + str(innocents_penalty) + "pts"
	doubters_value_label.text = "-50pts x " + str(doubters_number) + " = " + str(doubter_penalty) + "pts"
	total_value_label.text = "-" + str(total)

# BUTTONS
func _on_restart_button_pressed():
	LevelManager.reload_scene()
	_fade_panels()
	
func _on_menu_button_pressed():
	_fade_panels()
	LevelManager.change_scene("MAIN_MENU")
	
func _on_retry_button_pressed():
	LevelManager.reload_scene()
	_fade_panels()

func _on_next_button_pressed():
	var current_level = _get_current_level()
	if current_level > 0:
		if current_level < LevelManager.LAST_LVL:
			LevelManager.change_to_next_level(current_level)
		else:
			LevelManager.change_scene("END_SCREEN")
	
		_fade_panels()
	else:
		print("Non level script opened level UI.")
		

func _fade_panels() -> void:
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(level_complete_container, "modulate:a", 0., 1.)
	tween.tween_property(game_over_container, "modulate:a", 0., 1.)
	tween.tween_property(darken_rect, "modulate:a", 0., 1.)

func _hide_panels() -> void:
	game_over_container.hide()
	level_complete_container.hide()	

func _get_current_level() -> int:
	var current_level_name := get_tree().root.get_child(-1).name # get level number
	var regex = RegEx.new()
	regex.compile("LVL(?<digit>[0-9]+)")
	var result := regex.search(current_level_name)
	if result: 
		return int(result.get_string("digit"))
	else:
		return -1
