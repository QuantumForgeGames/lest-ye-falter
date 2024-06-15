

class_name Ball
extends CharacterBody2D

var NARROW_BOUNCE = (Vector2.UP * 8 + Vector2.RIGHT).normalized()
var WIDE_BOUNCE = (Vector2.UP + Vector2.RIGHT * 5).normalized()
var KICK_TIMEOUT_DURATION := 5.

@export var speed :float = 500
@export var MAX_SPEED :float = 600
@export var MIN_SPEED :float = 400

var can_kick: bool = true
@onready var kick_timer := $KickTimer

func _ready () -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

	randomize()
	var trajectory := Vector2(randf_range(-1., 1.), [randf_range(-1., -0.25), randf_range(0.25, 1.)].pick_random()).normalized()
	velocity = trajectory * speed


func _process (_delta :float) -> void:
	if Input.is_action_just_pressed("random_kick") and can_kick:
		_on_kick()
	else:
		_bounce(move_and_collide(velocity * _delta))


func _bounce (collision_ :KinematicCollision2D) -> void:
	if collision_ == null: return
	velocity = velocity.bounce(collision_.get_normal())
	var collider = collision_.get_collider()
	if collider is Paddle:
		var dist = global_position - collider.global_position
		dist = dist.project(Vector2.RIGHT)
		var ratio = abs(dist.x / collider.half_paddle_width)
		var trajectory = lerp(NARROW_BOUNCE, WIDE_BOUNCE, ratio).normalized()
		trajectory = lerp(trajectory, velocity.normalized(), 0.2).normalized()
		trajectory.x *= sign(velocity.x)
		velocity = trajectory * velocity.length() + collider.velocity 
		velocity = velocity.normalized() * clampf(MIN_SPEED, MAX_SPEED, velocity.length())

	$HitHandlerSystem.on_collision(collider)
		
func change_sprite() -> void:
	var duration := 0.5
	var tween := get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($Sprites/Filled, "modulate:a", 1 - $Sprites/Filled.modulate.a, duration)
	tween.tween_property($Sprites/Empty, "modulate:a", 1 - $Sprites/Empty.modulate.a, duration)

func _on_kick() -> void:
	can_kick = false
	kick_timer.start(KICK_TIMEOUT_DURATION)
	EventManager.kick_state_changed.emit(0., KICK_TIMEOUT_DURATION)
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.25)
	tween.tween_property(self, "scale", Vector2(1., 1.), 0.25)
	
	match int(signf(velocity.x)):
		0, 1: velocity = velocity.orthogonal()
		-1: velocity = velocity.orthogonal() * -1

func set_max_hits (val :int) -> void:
	$HitHandlerSystem/OnInput.MAX_HIT_COUNT = val
	$HitHandlerSystem/OnInput.hits_remaining = val

func _on_kick_timer_timeout() -> void:
	can_kick = true

func on_paddle_bounce() -> void:
	can_kick = true
	EventManager.kick_state_changed.emit(1., -1.)
