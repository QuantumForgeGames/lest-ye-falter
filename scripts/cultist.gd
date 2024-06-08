extends CharacterBody2D
class_name Cultist

var infected: bool = false

func on_hit():
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(0.75, 0.75), 1.)
	tween.tween_property(self, "position.y", 400, 2.)
	tween.tween_property(self, "position.x", -10, 2.)
	tween.tween_callback(func(): queue_free())
