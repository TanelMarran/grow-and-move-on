extends State

var so: Seed:
	get:
		if !so:
			so = get_state_owner()
		return so

var current_stage: int
var _stage_timer: float

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	so.waterable_area.body_entered.connect(on_watered)
	so.sprite.is_wobbling = true
	current_stage = 0
	_stage_timer = so.stage_duration
	
func state_exit() -> void:
	so.waterable_area.body_entered.disconnect(on_watered)
	so.sprite.is_wobbling = false
	
func state_update(_delta: float) -> void:
	_stage_timer -= _delta
	if _stage_timer <= 0:
		_stage_timer = so.stage_duration
		current_stage += 1
		should_flower()

func state_physics_update(_delta: float) -> void:
	animations()

func after_ready() -> void:
	pass

func on_watered(node: Node2D):
	var waterdrop: Waterdrop = node as Waterdrop
	if waterdrop:
		waterdrop.queue_free()
		current_stage += 1
		should_flower()
	
func animations():
	so.sprite.animation = "bulb"
	so.sprite.frame = current_stage
	if current_stage == so._number_of_stages - 1 && _stage_timer < so.stage_duration * .2:
		so.sprite.wobble_speed = 15

func should_flower() -> void:
	if current_stage == so._number_of_stages:
		goto_state("Flower")
