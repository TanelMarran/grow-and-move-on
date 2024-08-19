extends State

var so: Goal:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.goal_area.body_entered.connect(on_player_entered)
	
func state_exit() -> void:
	so.goal_area.body_entered.disconnect(on_player_entered)
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.target_vector = so.home_position - so.position
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()

func after_ready() -> void:
	pass

func on_player_entered(node: Node2D) -> void:
	var player: Player = node as Player
	if player:
		so.player = player
		goto_state("Confirmation")
		so.is_player_on_left = player.position.x < so.position.x
		player.reparent(so.player_joint_left if so.is_player_on_left else so.player_joint_right)
		so.movement_component.vector = (so.global_position - player.sprite.global_position).normalized() * so.jump_strength
		player.position = Vector2.ZERO
