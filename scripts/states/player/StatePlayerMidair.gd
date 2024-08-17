extends State

var so: Player:
	get:
		if !so:
			so = get_state_owner()
		return so

var is_jumping: bool = false

var animation_frame_speed_threshold = 10

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.movement_component.acceleration_factor = .8
	is_jumping = true
	
func state_exit() -> void:
	so.movement_component.acceleration_factor = 1
	
func state_update(_delta: float) -> void:
	so.tool_action()
	
func state_physics_update(_delta: float) -> void:
	var movement_input: float = (1 if Input.is_action_pressed("Move Right") else 0) - (1 if Input.is_action_pressed("Move Left") else 0)
	so.movement_component.target_vector.x = movement_input * so.stats.movement_speed
	so.movement_component.vector.y = so.movement_component.vector.y + Global.GRAVITY
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
	animations()
	
	if is_jumping && so.movement_component.vector.y > 0:
		is_jumping = false
	
	if is_jumping && Input.is_action_just_released("Jump"):
		is_jumping = false
		so.movement_component.vector.y *= .5
	
	if so.is_on_floor():
		goto_state("Grounded")

func animations() -> void:
	so.sprite.animation = "jump"
	so.sprite.frame = (0 if so.movement_component.vector.y < -animation_frame_speed_threshold else (2 if so.movement_component.vector.y > animation_frame_speed_threshold else 1))

func after_ready() -> void:
	pass
