extends State

@export var allow_jump: bool = false

var so: Player:
	get:
		if !so:
			so = get_state_owner()
		return so

var animation_frame_speed_threshold = 10
var coyote_time: float = .1
var coyote_timer: float = 0

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.movement_component.acceleration_factor = .8
	if previous_state == "Grounded":
		coyote_timer = coyote_time
	
func state_exit() -> void:
	so.movement_component.acceleration_factor = 1
	
func state_update(_delta: float) -> void:
	if coyote_timer > 0:
		coyote_timer -= _delta
	so.tool_action()
	so.pickup_action()
	
func state_physics_update(_delta: float) -> void:
	var movement_input: float = (1 if Input.is_action_pressed("Move Right") else 0) - (1 if Input.is_action_pressed("Move Left") else 0)
	so.movement_component.target_vector.x = movement_input * so.stats.movement_speed
	so.movement_component.apply_gravity(_delta)
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
	animations()
	
	if Input.is_action_just_pressed("Jump") && (coyote_timer > 0 && !so.is_jumping || allow_jump):
		so.jump()
	
	so.regulate_jump()
	
	if so.is_on_ceiling():
		so.movement_component.vector.y = max(0, so.movement_component.vector.y)
	
	if so.is_on_floor():
		goto_state("Grounded")

func animations() -> void:
	so.sprite.animation = "jump"
	so.sprite.frame = (0 if so.movement_component.vector.y < -animation_frame_speed_threshold else (2 if so.movement_component.vector.y > animation_frame_speed_threshold else 1))

func after_ready() -> void:
	pass
