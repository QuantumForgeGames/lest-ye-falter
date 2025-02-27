extends HitHandler

@export var entity: Ball
@export var MAX_HIT_COUNT: int = 10
var hits_remaining: int = MAX_HIT_COUNT
var can_serve: bool = false

func on_collision(body: PhysicsBody2D) -> void:
	if body is Paddle:
		if hits_remaining == 0: entity.change_sprite()
		if hits_remaining < MAX_HIT_COUNT: 
			AudioManager.play_stream_oneshot(AudioManager.audio_punchbowl_fill)
		elif entity.check_paddle_timer(): AudioManager.play_stream_oneshot(AudioManager.audio_reflect_leader)
		hits_remaining = MAX_HIT_COUNT
		entity.on_paddle_bounce()
	elif body is Cultist:
		if hits_remaining > 0 and can_serve:
			hits_remaining -= 1
			AudioManager.play_stream_oneshot(AudioManager.audio_punchbowl_drink.pick_random())
			body.on_hit()
			if hits_remaining == 0: entity.change_sprite()
		else: AudioManager.play_stream_oneshot(AudioManager.audio_reflect_cultist)
	elif entity.check_paddle_timer(): AudioManager.play_stream_oneshot(AudioManager.audio_reflect_wall)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("serve_punch"):
		can_serve = true
	elif event.is_action_released("serve_punch"):
		can_serve = false
		
