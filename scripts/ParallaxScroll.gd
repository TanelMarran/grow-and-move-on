class_name ParallaxScroll extends ParallaxLayer

@export var speed: Vector2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	motion_offset += speed * delta
