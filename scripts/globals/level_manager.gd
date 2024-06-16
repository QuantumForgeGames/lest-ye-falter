extends CanvasLayer

signal retry ()


var level_path_template = "res://scenes/levels/level%s.tscn"
@onready var animation_player := $AnimationPlayer

const MAX_LEVELS :int = 8

var scenes = {
	"MAIN_MENU": "res://scenes/menus/main_menu.tscn",
	"INSTRUCTIONS1": "res://scenes/menus/instructions1.tscn",
	"INSTRUCTIONS2": "res://scenes/menus/instructions2.tscn",
	"WIN_SCREEN": "res://scenes/menus/win_screen.tscn",
}

var LAST_LVL: int = 4
var LAST_LVL_PLUS :int = 8
var is_new_game_plus :bool = false


func _ready () -> void:
	for i in range(1, MAX_LEVELS +1):
		scenes["LVL%s" %i] = level_path_template %i


func change_to_next_level(current: int) -> void:
	change_scene("LVL%s" % (current + 1))


func change_scene(target: String) -> void:
	_change_scene(scenes[target])
	match target:
		"LVL4": is_new_game_plus = false
		"LVL7": is_new_game_plus = true
		"MAIN_MENU": is_new_game_plus = false


func _change_scene(target: String) -> void:
	AudioManager.reset_chanting()
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target)
	animation_player.play_backwards("fade")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE


func reload_scene() -> void:
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().reload_current_scene()
	animation_player.play_backwards("fade")
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	retry.emit()
