class_name Grower extends Resource

@export var growth_speed: float = 50
@export var point_frequency: float = 16

var is_growing: bool = false

func should_spawn_new_point(point1: Vector2, point2: Vector2) -> bool:
	return (point1 - point2).length() > point_frequency

func get_growth(delta: float) -> Vector2:
	return Vector2.UP * delta * growth_speed

func update_point(stem: Stem, index: int, growth: Vector2) -> void:
	stem.points[index] += growth
	stem.line_shapes[index].b += growth

func add_point(stem: Stem, index1: int, index2: int) -> void:
	var a: Vector2 = stem.points[index2]
	var b: Vector2 = stem.points[index1]
	if should_spawn_new_point(a, b):
		stem.add_point(b, index2)
		stem.add_new_shape(b)
