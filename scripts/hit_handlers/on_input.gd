extends HitHandler

@export var entity: Ball
@export var MAX_HIT_COUNT: int = 10
var hits_remaining: int = MAX_HIT_COUNT
var can_serve: bool = false

func on_collision(body: PhysicsBody2D) -> void:
	if body is Paddle:
		if hits_remaining == 0: entity.change_sprite()
		hits_remaining = MAX_HIT_COUNT
	elif body is Cultist and hits_remaining > 0 and can_serve:
		hits_remaining -= 1
		body.on_hit()
		if hits_remaining == 0: entity.change_sprite()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("serve_punch"):
		can_serve = true
	elif event.is_action_released("serve_punch"):
		can_serve = false
		
