extends State

var so: Goal:
	get:
		if !so:
			so = get_state_owner()
		return so

var is_showing_prompt: bool = false
@export var wait_time: float = 1
var _wait_timer: float

var stored_tool_visibility: bool

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	_wait_timer = wait_time
	if so.player:
		so.player.state_machine.active = false
		stored_tool_visibility = so.player.tool_anchor.visible
		so.player.tool_anchor.visible = false
	is_showing_prompt = false
	
func state_exit() -> void:
	Global.user_interface.game_end_prompt_finished.disconnect(on_prompt_show)
	Global.user_interface.toggle_game_end_prompt(false)
	is_showing_prompt = false
	
func state_update(_delta: float) -> void:
	if _wait_timer > 0:
		_wait_timer -= _delta
		if _wait_timer <= 0:
			Global.user_interface.toggle_game_end_prompt(true)
			Global.user_interface.game_end_prompt_finished.connect(on_prompt_show)
	
	if is_showing_prompt:
		if Input.is_action_just_pressed("Interact"):
			goto_state("Fly")
		elif Input.is_action_just_pressed("Jump"):
			if so.player:
				so.player.reparent(so.get_parent())
				so.player.jump()
				so.player.movement_component.vector.x = so.player_horizontal_strength * -1 if so.is_player_on_left else 1
				so.player.movement_component.vector += so.movement_component.vector
				so.player.state_machine.active = true
				so.goal_area.monitoring = false
				so.player.tool_anchor.visible = stored_tool_visibility
				get_tree().create_timer(.5).timeout.connect(func():
					so.goal_area.monitoring = true
				, CONNECT_ONE_SHOT)
				goto_state("Idle")
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.target_vector = (so.home_position - so.position) * 5
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()
	animations()

func after_ready() -> void:
	pass

func animations() -> void:
	if so.player:
		so.player.sprite.flip_h = so.is_player_on_left
		so.player.sprite.play("goal_wait")
		so.player.sprite.offset.y = so.sprite.offset.y

func on_prompt_show() -> void:
	is_showing_prompt = true
