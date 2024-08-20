class_name ToolAnchor extends Node2D

var tool: Node2D = null
var tool_sprite: AnimatedSprite2D = null

enum Direction {LEFT, RIGHT, UP, DOWN}

signal tool_picked_up
signal tool_dropped

var direction: Direction = Direction.LEFT:
	set(value):
		match (value):
			Direction.LEFT:
				rotation_degrees = 180
			Direction.RIGHT: 
				rotation_degrees = 0
			Direction.UP: 
				rotation_degrees = 270
			Direction.DOWN: 
				rotation_degrees = 90

func pickup(node: Node2D, sprite: AnimatedSprite2D, dropped_callback: Callable, distance: float = 18) -> void:
	rotation = 0
	node.position = Vector2(distance, 0)
	node.reparent(self, false)
	if tool:
		drop()
	
	tool = node
	tool_sprite = sprite
	tool_dropped.connect(dropped_callback, CONNECT_ONE_SHOT)
	tool_picked_up.emit(tool, sprite)

func drop() -> void:
	tool.position = get_owner().position + Vector2.UP * 8
	tool.rotation = 0
	tool.reparent(get_owner().get_parent(), false)
	tool = null
	tool_sprite.flip_v = false
	tool_sprite = null
	tool_dropped.emit(tool)
