extends HitHandler

func on_collision(body: PhysicsBody2D) -> void:
	if body is Cultist:
		body.on_hit()
