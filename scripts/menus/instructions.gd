extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("fade")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			SceneTransition.change_scene("res://scenes/levels/level1.tscn")
