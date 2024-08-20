extends Node

const RESTITUTION_GROUND: float = 300.0
const GRAVITY: float = 590.0
const GRAVITY_MAX: float = 120.0

var interactable: Array[PickupArea] = []
var valid_interactables: Array[PickupArea] = []

@onready var user_interface: UserInterface = get_tree().current_scene.get_node("/root/World/CanvasLayer")
@onready var player: Player = get_tree().get_nodes_in_group("Player")[0]

func _ready() -> void:
	call_deferred("_ready_deferred")

func _ready_deferred() -> void:
	user_interface.water_bar.amount_filled = player.water_amount
	player.water_reclaimed.connect(func():
		user_interface.water_bar.amount_filled += 1
	)
	player.water_used.connect(func():
		user_interface.water_bar.amount_filled -= 1
	)
	
	user_interface.tool_display.set_tool_texture(null)
	player.tool_anchor.tool_picked_up.connect(func(tool: Node2D, sprite: AnimatedSprite2D):
		user_interface.tool_display.set_tool_texture(sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame))
	)
	player.tool_anchor.tool_dropped.connect(func(tool: Node2D):
		user_interface.tool_display.set_tool_texture(null)
	)
	
	player.fruit_picked_up.connect(func():
		user_interface.fruit_counter.target_fruit += 1
	)
	player.fruit_used.connect(func(amount: int):
		user_interface.fruit_counter.target_fruit -= amount
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	valid_interactables = interactable.filter(func(interactable: PickupArea): return interactable.is_interactable)
