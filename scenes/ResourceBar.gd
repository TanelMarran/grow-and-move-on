@tool
class_name ResourceBar extends HBoxContainer

@export var filled: Texture2D
@export var empty: Texture2D
@export var amount_filled: int = 0:
	set(value):
		amount_filled = value
		for index in range(rects.size()):
			rects[index].texture = filled if value > index else empty

var rects: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node as TextureRect:
			rects.append(node as TextureRect)
