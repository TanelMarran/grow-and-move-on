extends State

var so: Waterdrop:
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
	so.movement_component.apply_gravity(_delta)
	
	if so.is_on_floor():
		so.queue_free()
		
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()

func after_ready() -> void:
	pass
