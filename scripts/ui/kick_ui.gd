extends CanvasLayer

@onready var bar := $TextureProgressBar
var tween: Tween = null
var reset_time: float = 0.25

func _ready() -> void:
	EventManager.kick_state_changed.connect(_set_progress_tween)
	
func _set_progress_tween(val: float, duration: float) -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
	
	if val == 1.:
		tween.tween_property(bar, "value", val, reset_time)
	elif val == 0.:
		tween.tween_property(bar, "value", val, reset_time)
		tween.tween_property(bar, "value", 1., duration)
