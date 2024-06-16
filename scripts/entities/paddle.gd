
class_name Paddle
extends CharacterBody2D


@export var speed = 700
@export var camera: Camera2D # Camera used to determine the bounds of movement
@export var _Ball: Ball

var direction = Vector2.ZERO
var camera_rect: Rect2
var half_paddle_width: float
var half_arm_width :float
var paddle_start_y :float

var camera_start_x :float
var camera_end_x :float

@onready var _Collision: CollisionShape2D = $Collision
@onready var _Collision2: CollisionShape2D = $Collision2

@onready var kick_emote: Sprite2D = $KickEmote
@onready var serve_emote: Sprite2D = $ServeEmote
@onready var unable_emote: Node2D = $Unable
var kick_tween: Tween = null
var serve_tween: Tween = null

var is_disabled: bool = false

func _ready () -> void:
	_draw_unable_emote()
	EventManager.cultist_convinced.connect(_on_minigame_ended)
	EventManager.cultist_escaped.connect(_on_minigame_ended)

	camera_rect = camera.get_viewport_rect()
	# Calculate half the width of the paddle for boundary checks
	half_paddle_width = _Collision.shape.get_rect().size.x / 2 * scale.x
	half_arm_width = _Collision2.shape.get_height() / 2 * scale.x

	# Calculate the left and right bounds of the camera view
	camera_start_x = camera.position.x - camera_rect.size.x / 2
	camera_end_x = camera_start_x + camera_rect.size.x
	paddle_start_y = global_position.y


func _process (_delta :float) -> void:
	_get_input()
	
	# Prevent the paddle from moving outside the camera bounds
	if not is_disabled:
		if global_position.x - half_arm_width < camera_start_x:
			global_position.x = camera_start_x + half_arm_width
		elif global_position.x + half_arm_width > camera_end_x:
			global_position.x = camera_end_x - half_arm_width

	# Update the paddle's velocity based on the current direction
	velocity = speed * direction
	move_and_slide()
	
	if Input.is_action_just_pressed("serve_punch"):
		show_serve_emote()
	elif Input.is_action_just_released("serve_punch"):
		hide_serve_emote()
	if Input.is_action_just_pressed("random_kick"):
		show_kick_emote()

func _get_input () -> void:
	direction = Input.get_axis("move_left", "move_right") * Vector2(1, 0)


func _on_capture_area_body_entered(body: Node2D) -> void:
	if process_mode != Node.PROCESS_MODE_DISABLED: # if mini game is not already active
		hide_serve_emote()
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		$CaptureArea.set_deferred("monitoring", false)	
		body.on_captured()
		EventManager.cultist_captured.emit(body)


func _on_minigame_ended(_cultist: Cultist) -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
	$CaptureArea.set_deferred("monitoring", true)

func exit_scene() -> Tween:
	$CaptureArea/CollisionShape2D.set_deferred("disabled", true)
	$Collision.set_deferred("disabled", true)
	$Collision2.set_deferred("disabled", true)
	is_disabled = true
	var ytarget := 525.
	var dir := int(global_position.x > get_viewport_rect().size.x / 2)
	var xtarget := dir * get_viewport_rect().size.x + (2 * dir - 1) * 150.
	
	return move_to_position(xtarget, ytarget)
	
func move_to_position(xtarget: float, ytarget: float) -> Tween:
	$AnimationPlayer.play("wobble")	
	var tween := get_tree().create_tween()
	#process_mode = Node.PROCESS_MODE_DISABLED
	
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.25)
	tween.parallel().tween_property(self, "scale", Vector2(0.7, 0.7), 1.5)
	tween.parallel().tween_property(self, "position:y", ytarget, abs(global_position.y - ytarget)/350)
	
	tween.tween_property(self, "position:x", xtarget, abs(global_position.x - xtarget)/350)
	tween.tween_callback(func(): $AnimationPlayer.stop())
	return tween

func show_kick_emote():
	unable_emote.visible = !_Ball.can_kick
	if kick_tween: kick_tween.kill()
	kick_tween = get_tree().create_tween()
	kick_tween.tween_property(kick_emote, "modulate:a", 1., 0.25)
	kick_tween.parallel().tween_property(unable_emote, "modulate:a", 1., 0.25)
	kick_tween.tween_interval(0.25)
	kick_tween.tween_property(kick_emote, "modulate:a", 0., 0.25)
	kick_tween.parallel().tween_property(unable_emote, "modulate:a", 0., 0.25)

func show_serve_emote():
	if serve_tween: serve_tween.kill()
	serve_tween = get_tree().create_tween()
	serve_tween.tween_property(serve_emote, "modulate:a", 1., 0.25)

func hide_serve_emote():
	if serve_tween: serve_tween.kill()
	serve_tween = get_tree().create_tween()
	serve_tween.tween_property(serve_emote, "modulate:a", 0., 0.25)


func _draw_unable_emote () -> void:
	unable_emote.draw.connect(func():
		unable_emote.draw_arc(Vector2.ZERO, 30., 0., TAU, 32, Color.RED, 4.)
		unable_emote.draw_line(Vector2(-20., -20.), Vector2(20., 20.), Color.RED, 4.)
	)
	unable_emote.queue_redraw()
