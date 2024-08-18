extends State

var so: Tool:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.pickup_area.is_interactable = true
	so.sprite.is_floating = true
	
func state_exit() -> void:
	so.pickup_area.is_interactable = false
	so.sprite.is_floating = false
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.target_vector.x = 0
	so.movement_component.apply_gravity(_delta)
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
