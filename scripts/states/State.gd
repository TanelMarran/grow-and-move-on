class_name State extends Node

var state_owner: Variant
var state_machine: StateMachine
var last_state: String

signal transitioned_to
signal return_to_last

func get_state_owner() -> Variant:
	return state_owner
	
func after_ready() -> void:
	pass

func state_enter() -> void:
	pass
	
func state_exit() -> void:
	pass
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	pass

func goto_state(state_name: String) -> void:
	transitioned_to.emit(self, state_name)

func goto_last() -> void:
	return_to_last.emit()
	
func get_previous_state() -> State:
	if state_machine:
		return state_machine.previous_state
		
	return null

func draw() -> void:
	pass
