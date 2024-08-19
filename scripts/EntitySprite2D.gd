class_name EntitySprite2D extends AnimatedSprite2D

@export_group("Flicker")
@export var is_flickering: bool = false
@export var flicker_intensity: float = .05
var _flicker_timer: float = randf() * 2

@export_group("Float")
@export var is_floating: bool = false
@export var float_magnitude: float = 1
@export var float_speed: float = 10
var _float_timer: float = randf() * 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_floating:
		_float_timer += delta * float_speed
		offset.y = sin(_float_timer) * float_magnitude
	else:
		offset.y = 0
	
	if is_flickering:
		_flicker_timer += delta
		modulate.a = 0 if int(_flicker_timer / flicker_intensity) % 2 == 0 else 1
	else:
		modulate.a = 1
