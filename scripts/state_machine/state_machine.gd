# adapted from https://www.sandromaglione.com/articles/how-to-implement-state-machine-pattern-in-godot
class_name StateMachine
extends Node
 
@export var current_state: State
var states: Dictionary = {}
 
func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_child_transitioned)
		else:
			push_warning("State machine contains child which is not 'State'")
			
	current_state.enter()
			
func _process(delta):
	current_state.process(delta)
		
func _physics_process(delta):
	current_state.physics_process(delta)

func on_hit() -> void:
	current_state.on_hit()

func on_child_transitioned(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != current_state:
			current_state.exit()
			new_state.enter()
			current_state = new_state
			EventManager.cultist_state_changed.emit(get_parent())
	else:
		push_warning("Called transition on a state that does not exist")
