class_name StatePlayerAction extends State

@export var little_jump: bool = true
@export var timer_exit: bool = true

var so: Player:
	get:
		if !so:
			so = get_state_owner()
		return so

var direction: ToolAnchor.Direction

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	var is_facing_left: bool = true if Input.is_action_pressed("Move Left") else (false if Input.is_action_pressed("Move Right") else so.sprite.flip_h)
	var down_input: bool = Input.is_action_pressed("Move Down")
	var up_input: bool = Input.is_action_pressed("Move Up")
	
	if !down_input && !up_input:
		direction = ToolAnchor.Direction.LEFT if is_facing_left else ToolAnchor.Direction.RIGHT
	else:
		direction = ToolAnchor.Direction.DOWN if down_input else ToolAnchor.Direction.UP
	
	so.tool_anchor.direction = direction
	if so.tool_anchor.tool_sprite:
		so.tool_anchor.tool_sprite.flip_v = is_facing_left
	so.sprite.flip_h = is_facing_left
	so.tool_anchor.visible = true
	if little_jump:
		so.movement_component.vector.y = min(-so.stats.jump_power * .5, so.movement_component.vector.y)
	
	if timer_exit:
		get_tree().create_timer(.3).timeout.connect(func():
			goto_state("Grounded" if so.is_on_floor() else "Midair")
		, CONNECT_ONE_SHOT)

func state_exit() -> void:
	so.tool_anchor.visible = false
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	var movement_input: float = (1 if Input.is_action_pressed("Move Right") else 0) - (1 if Input.is_action_pressed("Move Left") else 0)
	so.movement_component.target_vector.x = movement_input * so.stats.movement_speed
	so.movement_component.apply_gravity(_delta)
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
	animations()
	
	so.regulate_jump()

func animations() -> void:
	so.sprite.animation = "use"
	match (direction):
		ToolAnchor.Direction.UP:
			so.sprite.frame = 1
		ToolAnchor.Direction.DOWN:
			so.sprite.frame = 2
		_:
			so.sprite.frame = 0
