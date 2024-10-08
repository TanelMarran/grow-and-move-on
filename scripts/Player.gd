class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var tool_anchor: ToolAnchor
@export var state_machine: StateMachine
@export var sprite: EntitySprite2D
@export var alert_sprite: EntitySprite2D
@export var stats: StatsPlayer
@export var waterdrop_scene: PackedScene
@export_range(0, 3, 1) var water_amount: int = 0
@export var fruit_amount: int = 10

const WATER_MAX: int = 3

var is_jumping: bool = false
var current_pickup: Node2D

signal tool_dropped

signal fruit_picked_up
signal fruit_used(amount: int)
signal water_reclaimed
signal water_used

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.acceleration = stats.acceleration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tool_action() -> void:
	if Input.is_action_just_pressed("Action"):
		state_machine.goto_state("Action")

func pickup_fruit() -> void:
	fruit_amount += 1
	fruit_picked_up.emit()

func pickup_action() -> void:
	var has_pickups: bool = Global.valid_interactables.size() > 0
	
	alert_sprite.modulate.a = 1 if has_pickups else 0
	
	if Input.is_action_just_pressed("Interact"):
		if has_pickups:
			Global.valid_interactables[0].pickup()
		elif tool_anchor.tool:
			tool_anchor.drop()

func jump(strength: float = 1) -> void:
	movement_component.vector.y = -stats.jump_power
	is_jumping = true

func regulate_jump() -> void:
	if is_jumping && movement_component.vector.y > 0:
		is_jumping = false
	
	if is_jumping && !Input.is_action_pressed("Jump"):
		is_jumping = false
		movement_component.vector.y *= .5

func pickup(node: Node2D, sprite: AnimatedSprite2D, dropped_callback: Callable, distance: float = 18) -> void:
	tool_anchor.pickup(node, sprite, dropped_callback, distance)

func drop_camera() -> void:
	var camera: Camera2D = get_node("Camera2D") as Camera2D
	if camera:
		camera.reparent(get_tree().root.get_node("World"))

func reclaim_water() -> void:
	water_amount += 1
	water_reclaimed.emit()

func use_water() -> void:
	water_amount -= 1
	water_used.emit()
