class_name ToolAnchor extends Node2D

@export var sprite: AnimatedSprite2D

enum Direction {LEFT, RIGHT, UP, DOWN}

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
