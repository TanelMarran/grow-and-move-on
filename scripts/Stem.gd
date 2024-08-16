class_name Stem extends Line2D

@export var growth_left: float = 100
@export var grower: Grower

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if growth_left > 0:
		var growth: Vector2 = grower.get_growth(delta)
		grower.update_point(self, -1, growth)
		grower.add_point(self, -1, -2)
		growth_left -= growth.length()
	else:
		growth_left = 0

func grow(distance: float) -> void:
	growth_left = distance
