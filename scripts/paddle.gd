extends RigidBody2D

class_name Paddle

var direction = Vector2.ZERO
var camera_rect: Rect2
var half_paddle_width: float

@export var speed = 40000
@export var camera: Camera2D # Camera used to determine the bounds of movement

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	camera_rect = camera.get_viewport_rect()
	# Calculate half the width of the paddle for boundary checks
	half_paddle_width = collision_shape_2d.shape.get_rect().size.x / 2 * scale.x

func _physics_process(delta):
	# Update the paddle's velocity based on the current direction
	linear_velocity = speed * direction * delta
	
func _process(_delta):
	# Calculate the left and right bounds of the camera view
	var camera_start_x = camera.position.x - camera_rect.size.x / 2
	var camera_end_x = camera_start_x + camera_rect.size.x
	
	# Prevent the paddle from moving outside the camera bounds
	if global_position.x - half_paddle_width < camera_start_x:
		global_position.x = camera_start_x + half_paddle_width
	elif global_position.x + half_paddle_width > camera_end_x:
		global_position.x = camera_end_x - half_paddle_width

func _input(_event):
	if Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
