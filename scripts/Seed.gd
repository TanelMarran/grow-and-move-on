class_name Seed extends CharacterBody2D

@export var state_machine: StateMachine
@export var pickup_area: PickupArea
@export var plant_area: Area2D
@export var waterable_area: Area2D
@export var sprite: EntitySprite2D
@export var movement_component: MovementComponent
@export var action_state: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickup_area.picked_up.connect(picked_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func picked_up(player: Player) -> void:
	player.pickup(self, sprite, func(node: Node2D):
		dropped(player)
	, 13)
	
	player.state_machine.add_state(action_state)
	
	sprite.is_floating = false
	pickup_area.is_interactable = false
	state_machine.active = false
	
func dropped(player: Player) -> void:
	player.state_machine.remove_state(action_state)
	movement_component.vector = player.movement_component.vector
	pickup_area.is_interactable = true
	sprite.is_floating = true
	state_machine.active = true
