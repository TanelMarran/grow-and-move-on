class_name Goal extends CharacterBody2D

@export var movement_component: MovementComponent
@export var state_machine: StateMachine
@export var sprite: EntitySprite2D
@export var goal_area: Area2D
@export var player_joint_right: Node2D
@export var player_joint_left: Node2D

@export var jump_strength: float = 120
@export var player_horizontal_strength: float = 120
@export var flight_path: Curve2D

@onready var home_position: Vector2 = global_position

var player: Player
var is_player_on_left: bool

func _ready() -> void:
	movement_component.acceleration = 500.0
