

class_name Ball
extends CharacterBody2D

var NARROW_BOUNCE = (Vector2.UP * 4 + Vector2.RIGHT).normalized()
var WIDE_BOUNCE = (Vector2.UP + Vector2.RIGHT * 3).normalized()

@export var speed :float = 800


func _ready () -> void:
    motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

    randomize()
    var trajectory := Vector2(randf_range(-1., 1.), randf_range(-1., 1.)).normalized()
    velocity = trajectory * speed


func _process (_delta :float) -> void:
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
        trajectory = lerp(trajectory, velocity.normalized(), ratio)
        trajectory.x *= sign(velocity.x)
        velocity = trajectory * velocity.length() + collider.velocity 
        velocity = velocity.normalized() * clampf(400, 1000, velocity.length())
