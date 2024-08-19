extends State

@export var stem_scene: PackedScene

var so: Seed:
	get:
		if !so:
			so = get_state_owner()
		return so

func get_state_owner() -> Variant:
	return state_owner
	
func state_enter() -> void:
	var stem: Stem = stem_scene.instantiate()
	stem.position = so.position
	stem.grower.direction = so.rotation - PI * .5
	so.rotation = 0
	so.add_sibling(stem)
	stem.top_node = so
	
func state_exit() -> void:
	pass
	
func state_update(_delta: float) -> void:
	pass
	
func state_physics_update(_delta: float) -> void:
	animations()

func after_ready() -> void:
	pass

func animations() -> void:
	so.sprite.play("flower")
