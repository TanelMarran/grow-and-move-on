extends State

var so: Seed:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.waterable_area.body_entered.connect(on_watered)
	
func state_exit() -> void:
	so.waterable_area.body_entered.disconnect(on_watered)
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	animations()

func after_ready() -> void:
	pass

func on_watered(node: Node2D):
	var waterdrop: Waterdrop = node as Waterdrop
	if waterdrop:
		waterdrop.queue_free()
		goto_state("Flower")
	
func animations():
	so.sprite.play("bulb")
