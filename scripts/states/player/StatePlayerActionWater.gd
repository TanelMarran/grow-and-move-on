extends StatePlayerAction
	
@export var waterdrop_scene: PackedScene
	
func state_enter() -> void:
	super()
	spawn_water()

func state_exit() -> void:
	super()
	
func state_update(_delta: float) -> void:
	super(_delta)
	
func state_physics_update(_delta: float) -> void:
	super(_delta)

func spawn_water() -> void:
	if waterdrop_scene:
		var waterdrop: Waterdrop = waterdrop_scene.instantiate()
		var direction: Vector2 = Vector2.from_angle(so.tool_anchor.rotation)
		waterdrop.position = so.position + so.tool_anchor.position + direction * 16
		waterdrop.movement_component.vector = direction * waterdrop.stats.shoot_speed
		so.add_sibling(waterdrop)
		waterdrop.state_machine.goto_state("Shoot")
