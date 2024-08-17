class_name Player extends CharacterBody2D

@export var movement_component: MovementComponent
@export var tool_anchor: ToolAnchor
@export var state_machine: StateMachine
@export var sprite: AnimatedSprite2D
@export var stats: StatsPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.acceleration = stats.acceleration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tool_action() -> void:
	if Input.is_action_just_pressed("Action"):
		state_machine.goto_state("Action")
