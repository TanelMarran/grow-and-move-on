class_name Stem extends Line2D

@export var growth_left: float = 600
@export var grower: Grower

@export_group("Platform")
@export var platform_scene: PackedScene
@export var platform_distance_min: Vector2 = Vector2.ONE * 16
@export var platform_distance_max: Vector2 = Vector2.ONE * 32

var platforms: Array[Dictionary]

signal growth_finished

func _ready() -> void:
	pass

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
	
	if abs(diff_to_last_platform.x) > platform_distance_max.x || abs(diff_to_last_platform.y) > platform_distance_max.y:
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
