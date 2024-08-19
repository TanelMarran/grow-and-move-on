extends State

@export var expire_time: float = 10
@export var flash_time: float = 3
var _expire_timer: float

var so: Waterdrop:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	_expire_timer = expire_time
	so.reclaim_area.body_entered.connect(on_body_entered)
	so.sprite.play("grounded")
	
func state_exit() -> void:
	so.reclaim_area.body_entered.disconnect(on_body_entered)
	
func state_update(_delta: float) -> void:
	_expire_timer -= _delta
	if _expire_timer <= flash_time:
		so.sprite.is_flickering = true
	if _expire_timer <= 0:
		so.queue_free()
	
func state_physics_update(_delta: float) -> void:
	so.movement_component.target_vector = Vector2.ZERO
	so.movement_component.vector.y = 0
	
	if !so.is_on_floor():
		goto_state("Fall")
		
	so.movement_component.accelerate(_delta)
	so.movement_component.move_and_slide()

func after_ready() -> void:
	pass

func on_body_entered(node: Node2D) -> void:
	print(node)
	so.reclaim(node)
