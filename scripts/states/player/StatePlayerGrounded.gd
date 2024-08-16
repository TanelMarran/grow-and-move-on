extends State

var so: Player:
	get:
		if !so:
			so = get_state_owner()
		return so
	
func state_enter() -> void:
	pass
	
func state_exit() -> void:
	pass
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	var movement_input: float = (1 if Input.is_action_pressed("Move Right") else 0) - (1 if Input.is_action_pressed("Move Left") else 0)
	so.movement_component.target_vector.x = movement_input * so.stats.movement_speed
	so.movement_component.vector.y = 0
	
	if Input.is_action_just_pressed("Jump"):
		so.movement_component.vector.y = -so.stats.jump_power
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
	
	animations()
	
	if !so.is_on_floor():
		goto_state("Midair")

func animations() -> void:
	if so.movement_component.vector.x == 0:
		so.sprite.play("idle")
	else:
		so.sprite.flip_h = so.movement_component.vector.x < 0
		so.sprite.play("run")

func after_ready() -> void:
	pass
