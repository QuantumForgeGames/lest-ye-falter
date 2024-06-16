
class_name Paddle
extends CharacterBody2D


@export var speed = 700
@export var camera: Camera2D # Camera used to determine the bounds of movement

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
var kick_tween: Tween = null
var serve_tween: Tween = null

func _ready () -> void:
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
		set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
		$CaptureArea.set_deferred("monitoring", false)	
		body.on_captured()
		EventManager.cultist_captured.emit(body)


func _on_minigame_ended(_cultist: Cultist) -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
	$CaptureArea.set_deferred("monitoring", true)


func show_kick_emote():
	if kick_tween: kick_tween.kill()
	kick_tween = get_tree().create_tween()
	kick_tween.tween_property(kick_emote, "modulate:a", 1., 0.25)
	kick_tween.tween_property(kick_emote, "modulate:a", 0., 0.25).set_delay(0.25)

func show_serve_emote():
	if serve_tween: serve_tween.kill()
	serve_tween = get_tree().create_tween()
	serve_tween.tween_property(serve_emote, "modulate:a", 1., 0.25)

func hide_serve_emote():
	if serve_tween: serve_tween.kill()
	serve_tween = get_tree().create_tween()
	serve_tween.tween_property(serve_emote, "modulate:a", 0., 0.25)

