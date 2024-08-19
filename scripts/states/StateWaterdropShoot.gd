extends State

var so: Waterdrop:
	get:
		if !so:
			so = get_state_owner()
		return so

var fall_time = 0

var player_in: Player
var saved_mask: int

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	fall_time = so.stats.float_time
	saved_mask = so.collision_mask
	so.collision_mask = 0
	so.bounce_area.monitoring = true
	so.movement_component.is_sidescroller = false
	player_in = null
	so.bounce_area.body_entered.connect(on_player_entered)
	so.bounce_area.body_exited.connect(on_player_exited)
	
func state_exit() -> void:
	so.collision_mask = saved_mask
	so.bounce_area.monitoring = false
	so.movement_component.is_sidescroller = true
	so.bounce_area.body_entered.disconnect(on_player_entered)
	so.bounce_area.body_exited.disconnect(on_player_exited)
	
func state_update(_delta: float) -> void:
	fall_time -= _delta
	
	if fall_time <= 0:
		goto_state("Fall")
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.target_vector = Vector2.ZERO
	
	if player_in:
		if player_in.position.y > so.position.y:
			player_in.move_and_collide(Vector2(0, so.position.y - player_in.position.y))
			player_in.jump()
			player_in.move_and_slide()
			goto_state("Fall")
	
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()

func after_ready() -> void:
	pass

func on_player_entered(node: Node2D) -> void:
	if node is Player:
		player_in = node as Player
	
func on_player_exited(node: Node2D) -> void:
	if node is Player:
		player_in = null
