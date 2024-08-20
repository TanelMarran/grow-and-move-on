class_name EntitySprite2D extends AnimatedSprite2D

@export_group("Flicker")
@export var is_flickering: bool = false
@export var flicker_intensity: float = .05
var _flicker_timer: float = randf() * PI

@export_group("Wobble")
@export var is_wobbling: bool = false
@export var wobble_intensity: float = .1
@export var wobble_speed: float = 10
var _wobble_timer: float = randf() * PI

@export_group("Float")
@export var is_floating: bool = false
@export var float_magnitude: float = 1
@export var float_speed: float = 10
var _float_timer: float = randf() * PI

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
		
	if is_wobbling:
		_wobble_timer += delta
		var wobble_amount = sin(_wobble_timer * wobble_speed) * wobble_intensity
		scale.x = 1 + wobble_amount
		scale.y = 1 - wobble_amount
		rotation = cos(_wobble_timer * wobble_speed * .9) * PI * .05
	else:
		scale = Vector2.ONE
