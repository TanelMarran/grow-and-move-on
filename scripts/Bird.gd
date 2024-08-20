class_name Bird extends CharacterBody2D

@export var sprite: EntitySprite2D
@export var held_seed_anchor: Node2D
@export var drop_position_x: float = 0
@export var flight_zone_min: float = -200
@export var flight_zone_max: float = 200
@export var flight_zone_buffer: float = 24
@export var flight_speed: float = 64

var _held_seed: Seed
var _is_flying: bool = false

signal flight_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var seed: Seed = child as Seed
		if seed:
			hold_seed(seed)
			fly_and_drop(Vector2(drop_position_x, position.y), position.x < drop_position_x)
			break

func fly_and_drop(drop_position: Vector2, is_flying_right: bool = true) -> void:
	position.y = drop_position.y
	position.x = flight_zone_min - flight_zone_buffer if is_flying_right else flight_zone_max + flight_zone_buffer
	drop_position_x = drop_position.x
	velocity.x = flight_speed * (1 if is_flying_right else -1)
	sprite.flip_h = !is_flying_right
	_is_flying = true

func is_flying() -> bool:
	return _is_flying

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _held_seed && abs(position.x - drop_position_x) < 8:
		release_seed()
	if is_flying():
		if global_position.x > flight_zone_max + flight_zone_buffer || global_position.x < flight_zone_min - flight_zone_buffer:
			velocity.x = 0
			_is_flying = false
			flight_completed.emit()
	move_and_slide()

func hold_seed(seed: Seed) -> void:
	if seed.get_parent():
		seed.reparent(held_seed_anchor, false)
	else:
		held_seed_anchor.add_child(seed)
	seed.position = Vector2.ZERO
	seed.state_machine.active = false
	seed.sprite.is_floating = false
	_held_seed = seed

func release_seed() -> void:
	_held_seed.reparent(get_parent())
	_held_seed.state_machine.active = true
	_held_seed.sprite.is_floating = true
	_held_seed = null
