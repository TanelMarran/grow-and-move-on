class_name StateMachine extends Node

@export var state_owner: Node
@export var initial_state: State
@export var active: bool = true

var current_state: State
var states: Dictionary = {}

var previous_state: State

signal state_entered()

func _ready() -> void:
	for child in get_children():
		if child is State:
			add_state(child)

	if initial_state:
		initial_state.state_enter()
		current_state = initial_state

func add_state(state: State) -> void:
	var state_name = state.name.to_lower()
	
	if states.has(state_name):
		remove_state(states[state_name])
	
	states[state_name] = state
	state.state_owner = state_owner
	state.state_machine = self
	state.transitioned_to.connect(on_state_transition)
	state.return_to_last.connect(on_state_return_to_last)
	state.after_ready()
	
func remove_state(state: State) -> void:
	var state_name = state.name.to_lower()
	
	var remove_state_internal: Callable = func():
		states.erase(state_name)
		state.state_owner = null
		state.state_machine = null
		state.transitioned_to.disconnect(on_state_transition)
		state.return_to_last.disconnect(on_state_return_to_last)
	
	if current_state == state:
		current_state.transitioned_to.connect(func(state: State, new_state_name: String):
			remove_state_internal.call()
		, CONNECT_ONE_SHOT)
	else:
		remove_state_internal.call()
	
func _process(delta: float) -> void:
	if current_state && active:
		current_state.state_update(delta)
		
func _physics_process(delta: float) -> void:
	if current_state && active:
		current_state.state_physics_update(delta)

func goto_state(new_state_name: String) -> void:
	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		previous_state = current_state
		current_state.state_exit()
	
	new_state.state_enter()
	new_state.previous_state = current_state.name
	state_entered.emit(new_state_name)
	
	current_state = new_state

func on_state_transition(state: State, new_state_name: String) -> void:
	if state != current_state:
		return
		
	goto_state(new_state_name)

func on_state_return_to_last() -> void:
	if previous_state:
		goto_state(previous_state.name)
