extends CharacterBody2D
class_name Cultist

@export var speed: float = 400.

var infected: bool = false
var xbounds := get_viewport_rect().size.x

func on_hit():
	$CollisionShape2D.set_deferred("disabled", true)
	
	var ytarget := 600.
	var dir := int(global_position.x > xbounds / 2)
	var xtarget := dir * get_viewport_rect().size.x + (2 * dir - 1) * 50.
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.25)
	tween.tween_property(self, "scale", Vector2(1., 1.), 0.25)
	tween.tween_property(self, "position:y", ytarget, abs(global_position.y - ytarget)/speed)
	tween.tween_property(self, "position:x", xtarget, abs(global_position.x - xtarget)/speed)
	tween.tween_callback(func(): queue_free())
