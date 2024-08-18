class_name EntitySprite2D extends AnimatedSprite2D

@export_group("Float")
@export var is_floating: bool = false
@export var float_magnitude: float = 1
@export var float_speed: float = 10
var float_timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_floating:
		float_timer += delta * float_speed
		offset.y = sin(float_timer) * float_magnitude
	else:
		offset.y = 0
