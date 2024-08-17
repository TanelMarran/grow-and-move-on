class_name GrowerRightAngle extends Grower

@export_group("Rotation frequency")
@export var rot_frequency: float = 30
@export var rot_frequency_variance: float = 5

@export_group("Allowed directions")
@export var dir_min: float = 315
@export var dir_max: float = 225

@export_group("Rotation amount")
@export var rot_amount: float = 90
@export var rot_amount_variance: float = 0

var current_direction: float = deg_to_rad((dir_max + dir_min) / 2)
var growth_left_til_direction_change: float = get_random_next_rotation_time()

func get_random_next_rotation_time() -> float:
	return rot_frequency + randf_range(-1, 1) * rot_frequency_variance

func get_random_rotation_addition() -> float:
	return deg_to_rad([-1, 1].pick_random() * rot_amount + rot_amount_variance * randf_range(-1, 1))

func get_growth(delta: float) -> Vector2:
	return Vector2.from_angle(current_direction) * delta * growth_speed

func update_point(line: Line2D, index: int, growth: Vector2) -> void:
	growth_left_til_direction_change -= growth.length()
	
	if growth_left_til_direction_change < 0:
		var new_direction = current_direction + get_random_rotation_addition()
		while (angle_difference(new_direction, deg_to_rad(dir_max)) > 0 && angle_difference(new_direction, deg_to_rad(dir_min)) < 0):
			new_direction = current_direction + get_random_rotation_addition()
		current_direction = new_direction
		growth_left_til_direction_change = get_random_next_rotation_time()
	
	super(line, index, growth)
