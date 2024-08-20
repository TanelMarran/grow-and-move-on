class_name Tool extends CharacterBody2D

@export var state_machine: StateMachine
@export var pickup_area: PickupArea
@export var sprite: EntitySprite2D
@export var movement_component: MovementComponent
@export var action_state: State

signal tool_picked_up(player: Player)
signal tool_dropped(player: Player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickup_area.picked_up.connect(picked_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func picked_up(player: Player) -> void:
	player.pickup(self, sprite, func(node: Node2D):
		dropped(player)
	)
	
	player.state_machine.add_state(action_state)
	
	sprite.is_floating = false
	pickup_area.is_interactable = false
	state_machine.active = false
	tool_picked_up.emit(player)
	
func dropped(player: Player) -> void:
	player.state_machine.remove_state(action_state)
	movement_component.vector = player.movement_component.vector
	pickup_area.is_interactable = true
	sprite.is_floating = true
	state_machine.active = true
	tool_dropped.emit(player)
