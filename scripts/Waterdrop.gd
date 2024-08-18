class_name Waterdrop extends CharacterBody2D

@export var state_machine: StateMachine
@export var stats: StatsWaterdrop
@export var movement_component: MovementComponent
@export var bounce_area: Area2D
@export var reclaim_area: Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
