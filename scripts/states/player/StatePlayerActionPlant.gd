extends StatePlayerAction

@export var seed: Seed

var is_planted: bool = false
	
func state_enter() -> void:
	is_planted = false
	super()

func state_exit() -> void:
	super()
	
func state_update(_delta: float) -> void:
	super(_delta)
	
func state_physics_update(_delta: float) -> void:
	super(_delta)
	if !is_planted:
		var overlapping_areas: Array[Area2D] = seed.plant_area.get_overlapping_areas()
		if overlapping_areas.size() > 0:
			plant(seed.global_position)

func get_stem_normal() -> Vector2:
	var world_space: PhysicsDirectSpaceState2D = so.get_world_2d().direct_space_state
	var params: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	params.shape = (seed.plant_area.get_child(0) as CollisionShape2D).shape
	params.collide_with_bodies = false
	params.collide_with_areas = true
	params.collision_mask = seed.plant_area.collision_mask
	params.exclude = [seed.plant_area.get_rid()]
	params.transform = seed.plant_area.get_global_transform()
	var collision = world_space.get_rest_info(params)
	if collision:
		var normal: Vector2 = collision["normal"]
		if abs(normal.x) > abs(normal.y):
			normal.x = sign(normal.x)
			normal.y = 0
		else:
			normal.x = 0
			normal.y = sign(normal.y)
		return normal
		
	return Vector2.ZERO
	

func plant(plant_position: Vector2) -> void:
	so.tool_anchor.drop()
	is_planted = true
	seed.position = plant_position
	seed.rotation = Vector2.UP.angle_to(get_stem_normal())
	seed.state_machine.goto_state("Bulb")
	so.jump(.5)
