extends CanvasLayer

var level_path_template = "res://scenes/levels/level%s.tscn"
@onready var animation_player := $AnimationPlayer

var scenes = {
	"MAIN_MENU": "res://scenes/menus/main_menu.tscn",
	"INSTRUCTIONS1": "res://scenes/menus/instructions1.tscn",
	"INSTRUCTIONS2": "res://scenes/menus/instructions2.tscn",
	"LVL1": level_path_template % 1,
	"LVL2": level_path_template % 2, 
	"LVL3": level_path_template % 3,
	"LVL4": level_path_template % 4,
	"LVL5": level_path_template % 5,
	"WIN_SCREEN": null
}

var LAST_LVL: int = 5

func change_to_next_level(current: int) -> void:
	change_scene("LVL%s" % (current + 1))
	
func change_scene(target: String) -> void:
	_change_scene(scenes[target])

func _change_scene(target: String) -> void:
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
