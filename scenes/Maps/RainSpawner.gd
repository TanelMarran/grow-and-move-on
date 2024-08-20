extends Area2D

@export var spawn_area: CollisionShape2D
@export var spawn_frequency: float = 15
@export var spawn_variance: float = 5
@export var spawn_scene: PackedScene
@export var spawn_initial_time: float = 5
@onready var _spawn_timer: float = spawn_initial_time + spawn_variance * randf_range(-1, 1)

var _extents: Rect2

func _ready() -> void:
	_extents = spawn_area.shape.get_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_spawn_timer -= delta
	if _spawn_timer <= 0:
		_spawn_timer = spawn_frequency + spawn_variance * randf_range(-1, 1)
		var scene: Node2D = spawn_scene.instantiate()
		scene.position = spawn_area.global_position + _extents.position + Vector2(randf() * _extents.size.x, randf() * _extents.size.y)
		scene.modulate.a = 0
		get_tree().create_tween().tween_property(scene, "modulate", Color.WHITE, 1)
		add_sibling(scene)
