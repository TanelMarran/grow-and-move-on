class_name StateMachine extends Node

@export var state_owner: Node
@export var initial_state: State

var current_state: State
var states: Dictionary = {}

var previous_state: State

signal state_entered()

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_owner = state_owner
			child.state_machine = self
			child.transitioned_to.connect(on_state_transition)
			child.return_to_last.connect(on_state_return_to_last)
			child.after_ready()

	if initial_state:
		initial_state.state_enter()
		current_state = initial_state
	
func _process(delta: float) -> void:
	if current_state:
		current_state.state_update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.state_physics_update(delta)

func goto_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		previous_state = current_state
		current_state.state_exit()
	
	new_state.state_enter()
	state_entered.emit(new_state_name)
	
	current_state = new_state

func on_state_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
		
	goto_state(new_state_name)

func on_state_return_to_last() -> void:
	if previous_state:
		goto_state(previous_state.name)
