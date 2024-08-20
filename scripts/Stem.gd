class_name Stem extends Line2D

@export var growth_left: float = 600
@export var grower: Grower
@export var collision_area: Area2D

@export_group("Platform")
@export var platform_scene: PackedScene
@export var platform_distance: Vector2 = Vector2.ONE * 32
@export var initial_platform_distance_factor: float = .5

@export_group("Avoidance")
@export_flags_2d_physics var avoidance_mask: int = 0
@export var number_of_avoidance_rays: int = 9
@export var avoidance_cone_angle: float = 90
@export var avoidance_distance: float = 24
@export var is_avoidance_active: bool = true

var platforms: Array[Dictionary]

var line_shapes: Array[SegmentShape2D]

signal growth_finished

var top_node: Node2D = null:
	set(value):
		top_node = value
		top_node.reparent(self)
		top_node.position = points[-1]

func _ready() -> void:
	line_shapes.append(collision_area.get_child(0).shape as SegmentShape2D)
	is_avoidance_active = false
	get_tree().create_timer(.5).timeout.connect(func():
		is_avoidance_active = true
	, CONNECT_ONE_SHOT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if growth_left > 0:
		var growth: Vector2 = grower.get_growth(delta)
		grower.update_point(self, -1, growth)
		grower.add_point(self, -1, -2)
		growth_left -= growth.length()
		spawn_platforms()
		if growth_left <= 0:
			growth_finished.emit()
	else:
		growth_left = 0

func grow(distance: float) -> void:
	growth_left = distance

func get_last_platform_position() -> Vector2:
	if platforms.size() == 0:
		return points[0]
		
	return platforms[-1]['position']

func spawn_platforms() -> void:
	var last_platform_position: Vector2 = get_last_platform_position()
	var diff_to_last_platform: Vector2 = last_platform_position - points[-1]
	var distance_required: Vector2 = platform_distance * (initial_platform_distance_factor if platforms.size() == 0 else 1)
	
	if abs(diff_to_last_platform.x) > distance_required.x || abs(diff_to_last_platform.y) > distance_required.y && growth_left > distance_required.length() * .5:
		spawn_platform(points[-1], points.size() - 1)

func spawn_platform(platform_position, index):
	if platform_scene:
		var platform: Node2D = platform_scene.instantiate()
		platform.position = platform_position
		platforms.append({
			'index': index,
			'position': platform_position,
			'node': platform
		})
		add_child(platform)

func add_new_shape(a: Vector2) -> void:
	if collision_area:
		var collision_shape: CollisionShape2D = CollisionShape2D.new()
		var segment_shape: SegmentShape2D = SegmentShape2D.new()
		segment_shape.a = a
		segment_shape.b = a
		collision_shape.shape = segment_shape
		collision_area.add_child(collision_shape)
		line_shapes.append(segment_shape)

func get_average_avoidance_point():
	if !is_avoidance_active:
		return null
	
	var world_space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var current_ray_angle: float = grower.direction - avoidance_cone_angle * .5
	var ray_angle_step: float = deg_to_rad(avoidance_cone_angle / (number_of_avoidance_rays - 1))
	var intersections: Array[Vector2] = []
	
	for i in range(number_of_avoidance_rays):
		var params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.new()
		params.collide_with_areas = true
		params.collide_with_bodies = false
		params.collision_mask = avoidance_mask
		params.from = global_position + points[-1] + Vector2.from_angle(grower.direction) * 4
		params.to = params.from + Vector2.from_angle(current_ray_angle) * avoidance_distance
		current_ray_angle += ray_angle_step
		var result: Dictionary = world_space.intersect_ray(params)
		if get_tree().debug_collisions_hint:
			queue_redraw()
		if result.has("position"):
			intersections.append(result["position"])
	
	if intersections.size() > 0:
		return intersections.reduce(func(a, b): return a + b) / intersections.size()
	
	return null

func _draw() -> void:
	if get_tree().debug_collisions_hint:
		var current_ray_angle: float = grower.direction - deg_to_rad(avoidance_cone_angle * .5)
		var ray_angle_step: float = deg_to_rad(avoidance_cone_angle / (number_of_avoidance_rays - 1))
		
		for i in range(number_of_avoidance_rays):
			var from: Vector2 = points[-1] + Vector2.from_angle(grower.direction) * 4
			var to: Vector2 = from + Vector2.from_angle(current_ray_angle) * avoidance_distance
			current_ray_angle += ray_angle_step
			draw_line(from, to, Color.RED, 1)
