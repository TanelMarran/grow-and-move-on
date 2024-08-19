class_name Waterdrop extends CharacterBody2D

@export var state_machine: StateMachine
@export var sprite: EntitySprite2D
@export var stats: StatsWaterdrop
@export var movement_component: MovementComponent
@export var bounce_area: Area2D
@export var reclaim_area: Area2D
@export_flags_2d_physics var shoot_mask: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reclaim(node: Node2D) -> void:
	var player = node as Player
	if player && player.water_amount < player.WATER_MAX:
		player.reclaim_water()
		queue_free()
