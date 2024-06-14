extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	await get_tree().create_timer(1).timeout 
	LevelManager.change_scene("res://scenes/menus/main_menu.tscn")
