extends ParallaxScroll

@export var cloud_start: float = -438
@export var cloud_height: float = 285
@export var reference_node: Node2D
@export var cloud_background: Array[Node2D]
@export var fade_speed: float = 2

var target_alpha: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)
	if reference_node.position.y < cloud_start && reference_node.position.y > cloud_start - cloud_height:
		target_alpha = .5
	else:
		target_alpha = 1 
	modulate.a += (target_alpha - modulate.a) * fade_speed * delta
	var target_alpha_layer = 1 - ((target_alpha - .5) * 2)
	for node in cloud_background:
		node.modulate.a += (target_alpha_layer - node.modulate.a) * fade_speed * delta
