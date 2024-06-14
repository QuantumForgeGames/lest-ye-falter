extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("blink")

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			LevelManager.change_scene("LVL1")
