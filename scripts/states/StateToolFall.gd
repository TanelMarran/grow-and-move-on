extends State

var so: Waterdrop:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.reclaim_area.body_entered.connect(on_body_entered)
	so.sprite.play("idle")
	
func state_exit() -> void:
	so.reclaim_area.body_entered.disconnect(on_body_entered)
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.apply_gravity(_delta)
	
	if so.is_on_floor():
		goto_state("Grounded")
		
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()

func after_ready() -> void:
	pass

func on_body_entered(node: Node2D) -> void:
	so.reclaim(node)
