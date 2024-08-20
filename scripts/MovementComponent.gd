class_name MovementComponent extends Node

@onready var body: CharacterBody2D = get_owner()

@export var is_sidescroller: bool = true

var vector_scalar: float = 1

var target_vector: Vector2 = Vector2(0, 0):
	get:
		return target_vector * vector_scalar
var vector: Vector2 = target_vector:
	get:
		return vector * vector_scalar
	set(value):
		if is_sidescroller:
			target_vector.y = value.y 
		
		vector = value

var active: bool = false

var acceleration: float = 1200.0:
	get:
		return acceleration * acceleration_factor
var acceleration_factor: float = 1.0

var restitution: float = Global.RESTITUTION_GROUND:
	get:
		return restitution * restitution_factor
var restitution_factor: float = 1.0

var is_move_to_active: bool
var move_to_target: Vector2
var move_to_speed: float
var move_to_last_diff: float

signal move_to_completed(move_to_target: Vector2)

func set_movement_factors(_acceleration_factor: float = 1.0, _deacceleration_factor: float = 1.0):
	acceleration_factor = _acceleration_factor
	restitution_factor = _deacceleration_factor

func get_raw_acceleration():
	return acceleration
	
func get_raw_restitution():
	return restitution

func _physics_process(delta) -> void:
	if is_move_to_active:
		var diff : Vector2 = move_to_target - get_owner().position
		set_target_vector(diff, move_to_speed, move_to_speed)
		if (diff).length() < move_to_speed * delta || get_owner().get_slide_collision_count():
			clear_move_to()
	
	if active:
		accelerate(delta)

func accelerate(delta: float) -> void:
	approach_target_vector(target_vector, (delta * acceleration if !target_vector.is_equal_approx(Vector2.ZERO) else 0))
	approach_target_vector(Vector2(0, vector.y) if is_sidescroller else Vector2.ZERO, delta * restitution)

func set_target_vector(value: Vector2, max: float = value.length(), min: float = value.length()) -> void:
	var smallest_length: float = min(max, value.length())
	var largest_length: float = max(smallest_length, min)
	
	target_vector = value.normalized() * largest_length

func approach_target_vector(target: Vector2, amount: float) -> void:
	var diff: Vector2 = target - vector
	
	var add_vector: Vector2 = diff.normalized() * min(abs(diff.length()), abs(amount))
	
	vector += add_vector

func move_and_slide():
	if body:
		body.velocity = vector
		body.move_and_slide()

func clear_move_to() -> void:
	if move_to_target && is_move_to_active:
		is_move_to_active = false
		move_to_completed.emit(move_to_target)
	else:
		is_move_to_active = false

func set_move_to_target(new_target: Vector2) -> void:
	move_to_target = new_target

func get_move_to_target() -> Vector2:
	return move_to_target

func move_to(position: Vector2, speed: float) -> void:
	is_move_to_active = true
	move_to_target = position
	move_to_speed = speed

func apply_gravity(_delta: float) -> void:
	vector.y = min(vector.y + Global.GRAVITY * _delta, Global.GRAVITY_MAX)
