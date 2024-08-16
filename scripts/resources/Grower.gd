class_name Grower extends Resource

@export var growth_speed: float = 50
@export var point_frequency: float = 16

var is_growing: bool = false

func should_spawn_new_point(point1: Vector2, point2: Vector2) -> bool:
	return (point1 - point2).length() > point_frequency

func get_growth(delta: float) -> Vector2:
	return Vector2.UP * delta * growth_speed

func update_point(line: Line2D, index: int, growth: Vector2) -> void:
	line.points[index] += growth

func add_point(line: Line2D, index1: int, index2: int) -> void:
	if should_spawn_new_point(line.points[index1], line.points[index2]):
			line.add_point(line.points[index1], index2)
