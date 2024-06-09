extends HitHandler

@export var MAX_HIT_COUNT: int = 1
var hits_remaining: int = MAX_HIT_COUNT
 
func on_collision(body: PhysicsBody2D) -> void:
	if body is Paddle:
		hits_remaining = MAX_HIT_COUNT
	elif body is Cultist and hits_remaining > 0:
		hits_remaining -= 1
		body.on_hit()
