class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var tool_anchor: ToolAnchor
@export var state_machine: StateMachine
@export var sprite: AnimatedSprite2D
@export var stats: StatsPlayer
@export var waterdrop_scene: PackedScene

var is_jumping: bool = false
var current_pickup: Node2D

signal tool_dropped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.acceleration = stats.acceleration
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tool_action() -> void:
	if Input.is_action_just_pressed("Action"):
		state_machine.goto_state("Action")

func pickup_action() -> void:
	if Input.is_action_just_pressed("Interact"):
		if Global.valid_interactables.size() > 0:
			Global.valid_interactables[0].pickup()
		elif tool_anchor.tool:
			tool_anchor.drop()

func jump() -> void:
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
