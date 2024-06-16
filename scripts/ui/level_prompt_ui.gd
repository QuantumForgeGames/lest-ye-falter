extends CanvasLayer

@onready var game_over_container = %GameOverContainer
@onready var level_complete_container = %LevelCompleteContainer
@onready var innocents_value_label: Label = %InnocentsValueLabel
@onready var doubters_value_label: Label = %DoubtersValueLabel
@onready var total_value_label: Label = %TotalValueLabel
@onready var star_progress = %StarProgress
@onready var darken_rect = %DarkenRect

var game_total :float = 0
var level_total :float = 0
var level_max_count :float = 0

var lose_options := {
	"DOUBT": "Faith falters and dissenters \n thrive; your reign ends.",
	"ESCAPE": "Too many have abandoned you. \n Your cult dwindles."
}


func _ready() -> void:
	_hide_panels()
	_fade_panels()
	EventManager.level_won.connect(_on_level_won)
	EventManager.level_lost.connect(_on_level_lost)


func _on_level_lost():
	game_over_container.show()
	var tween := self.create_tween()
	tween.tween_property(darken_rect, "modulate:a", 1., 1.)
	tween.tween_property(game_over_container, "modulate:a", 1., 1.)
	tween.tween_callback(func(): get_tree().paused = true)


func _on_level_won():
	var current_level := _get_current_level()
	if current_level > 0:
		level_complete_container.show()
		var tween := self.create_tween()
		tween.tween_property(darken_rect, "modulate:a", 1., 1.)
		tween.tween_property(level_complete_container, "modulate:a", 1., 1.)
		tween.tween_callback(func(): get_tree().paused = true)
		tween.tween_property(innocents_value_label, "self_modulate:a", 1.0, 1.)
		tween.tween_property(doubters_value_label, "self_modulate:a", 1.0, 1.)
		tween.tween_property(total_value_label, "self_modulate:a", 1.0, 1.)
		var percent = (level_max_count *100. + level_total) / (level_max_count *100.)
		tween.tween_property(star_progress, "value", abs(percent), 1.5) # progress bar
	else:
		print("Non level script calling _on_level_won.")


# SCORING
func _handle_scoring(innocents_number, doubters_number):
	var innocents_penalty: float = -100.0 * innocents_number
	var doubter_penalty: float = -50.0 * doubters_number
	level_total = innocents_penalty + doubter_penalty
	game_total += level_total
	innocents_value_label.text = "-100pts x " + str(innocents_number) + " = " + str(innocents_penalty) + "pts"
	doubters_value_label.text = "-50pts x " + str(doubters_number) + " = " + str(doubter_penalty) + "pts"
	total_value_label.text = str(level_total) + "pts"


# BUTTONS
func _on_hover() -> void:
	AudioManager.play_stream_oneshot(AudioManager.audio_misc_hover)

func _on_restart_button_pressed():
	AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
	_fade_panels()
	LevelManager.reload_scene()


func _on_menu_button_pressed():
	AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
	_fade_panels()
	LevelManager.change_scene("MAIN_MENU")


func _on_retry_button_pressed():
	AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
	_fade_panels()
	LevelManager.reload_scene()


func _on_next_button_pressed():
	AudioManager.play_stream_oneshot(AudioManager.audio_misc_press)
	var current_level = _get_current_level()
	if current_level > 0:
		match current_level:
			1, 2, 3, 5, 6, 7:
				LevelManager.change_to_next_level(current_level)
				_fade_panels()
			_:
				_fade_panels()
				var tween: Tween = get_tree().root.get_child(-1).get_node("Paddle").exit_scene()
				await tween.finished
				LevelManager.change_scene("WIN_SCREEN")
	else:
		print("Non level script opened level UI.")



func _fade_panels() -> void:
	if get_tree().paused: get_tree().paused = false
	var tween := self.create_tween()
	tween.set_parallel()
	tween.tween_property(level_complete_container, "modulate:a", 0., 1.)
	tween.tween_property(game_over_container, "modulate:a", 0., 1.)
	tween.tween_property(darken_rect, "modulate:a", 0., 1.)
	tween.tween_property(innocents_value_label, "self_modulate:a", 0., 1.)
	tween.tween_property(doubters_value_label, "self_modulate:a", 0., 1.)
	tween.tween_property(total_value_label, "self_modulate:a", 0., 1.)
	tween.tween_property(star_progress, "value", 0., 1.)


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


func set_lose_text(state: String):
	$GameOverContainer/Background/MarginContainer/VBoxContainer/TitleLabel.text = lose_options[state]
