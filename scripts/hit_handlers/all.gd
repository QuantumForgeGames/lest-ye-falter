extends HitHandler

func on_collision(body: PhysicsBody2D) -> void:
	body.on_hit()
