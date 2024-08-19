extends State

var so: Goal:
	get:
		if !so:
			so = get_state_owner()
		return so
		
var follower: PathFollow2D
@export var wait_time: float = 3
var _wait_timer: float
var is_flying: bool = false
var baked_length: float

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	var path: Path2D = Path2D.new()
	path.curve = so.flight_path
	path.position = so.position
	so.add_sibling(path)
	follower = PathFollow2D.new()
	follower.rotates = false
	path.add_child(follower)
	so.reparent(follower)
	_wait_timer = wait_time
	is_flying = false
	so.movement_component.set_movement_factors(.7)
	baked_length = so.flight_path.get_baked_length()
	
func state_exit() -> void:
	pass
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	if _wait_timer > 0:
		_wait_timer -= _delta
		if _wait_timer <= 0:
			is_flying = true
			# so.player.drop_camera()
	if is_flying:
		so.movement_component.target_vector.x = 250
		follower.progress = min(baked_length, follower.progress + so.movement_component.vector.x * _delta)
	animations()
	so.movement_component.accelerate(_delta)

func after_ready() -> void:
	pass

func animations() -> void:
	if so.player:
		so.player.sprite.flip_h = so.is_player_on_left
		so.player.sprite.play("goal_wave")
		so.player.sprite.offset.y = so.sprite.offset.y
