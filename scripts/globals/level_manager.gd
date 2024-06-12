extends CanvasLayer

var level_path_template = "res://src/scenes/levels/level%s.tscn"
@onready var animation_player := $AnimationPlayer

func change_level(level_number: int):
	var scene_filename = level_path_template % level_number
	change_scene(scene_filename)

func change_scene(target: String) -> void:
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
