extends State

var so: Seed:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	pass
	
func state_exit() -> void:
	pass
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	pass

func after_ready() -> void:
	pass
