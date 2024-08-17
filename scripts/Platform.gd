extends AnimatableBody2D

@export var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite:
		sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count("default") - 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
