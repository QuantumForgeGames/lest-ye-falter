extends Node

@export var hit_handler: HitHandler

func on_collision(body: PhysicsBody2D) -> void:
	if body is Cultist:
		hit_handler.on_collision(body)
