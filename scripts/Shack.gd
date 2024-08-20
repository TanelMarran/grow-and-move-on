extends Sprite2D

@export var pickup_area: PickupArea
@export var tool_scene: PackedScene

var tool: Tool
var is_tool_picked_up: bool = false:
	set(value):
		is_tool_picked_up = value
		pickup_area.is_interactable = !is_tool_picked_up
		print(!is_tool_picked_up)

func _ready() -> void:
	pickup_area.picked_up.connect(on_player_pickup)
	
func _process(delta: float) -> void:
	pass #print(pickup_area.is_interactable)
	
func on_player_pickup(player: Player) -> void:
	if !tool:
		tool = tool_scene.instantiate()
		tool.position = pickup_area.position
		add_sibling(tool)
		tool.tool_picked_up.connect(func(player: Player):
			is_tool_picked_up = true
		)
		tool.tool_dropped.connect(func(player: Player):
			is_tool_picked_up = false
		)
	
	tool.picked_up(player)
