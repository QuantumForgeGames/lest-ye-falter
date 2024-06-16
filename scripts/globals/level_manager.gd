extends CanvasLayer

signal retry ()


var level_path_template = "res://scenes/levels/level%s.tscn"
@onready var animation_player := $AnimationPlayer

const MAX_LEVELS :int = 8

var scenes = {
	"MAIN_MENU": "res://scenes/menus/main_menu.tscn",
	"INSTRUCTIONS1": "res://scenes/menus/instructions1.tscn",
	"INSTRUCTIONS2": "res://scenes/menus/instructions2.tscn",
	"WIN_SCREEN": null
}

var LAST_LVL: int = 8


func _ready () -> void:
	for i in range(1, MAX_LEVELS +1):
		scenes["LVL%s" %i] = level_path_template %i


func change_to_next_level(current: int) -> void:
	change_scene("LVL%s" % (current + 1))


func change_scene(target: String) -> void:
	_change_scene(scenes[target])


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
