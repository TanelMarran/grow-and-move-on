class_name Fruit extends CharacterBody2D

@export var claim_area: Area2D
@export var movement_component: MovementComponent
@export var deactive_time: float = 1.5
@export var deactive_time_variance: float = .5
@export var restitution: float = 500
@onready var _deactive_timer: float = deactive_time + randf_range(-deactive_time_variance, deactive_time_variance)

var active: bool = false

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_component.restitution = restitution
	movement_component.acceleration = restitution * 1.5
	claim_area.body_entered.connect(on_player_entered)
	claim_area.body_exited.connect(on_player_exited)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_deactive_timer -= delta
	if _deactive_timer <= 0:
		active = true
	
	if active:
		movement_component.target_vector = (Global.player.sprite.global_position - position).normalized() * 240
		
		if player:
			player.pickup_fruit()
			queue_free()
	else:
		movement_component.target_vector = Vector2.ZERO
		
	movement_component.accelerate(delta)
	movement_component.move_and_slide()

func on_player_entered(node: Node2D) -> void:
	player = node as Player

func on_player_exited(node: Node2D) -> void:
	if node as Player:
		player = null
