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

var current_direction: Vector2 = Vector2.from_angle(deg_to_rad((dir_max + dir_min) / 2))

func get_growth(delta: float) -> Vector2:
	return current_direction * delta * growth_speed

func update_point(line: Line2D, index: int, growth: Vector2) -> void:
	super(line, index, growth)
