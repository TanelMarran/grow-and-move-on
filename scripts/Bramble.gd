class_name Bramble extends Area2D

@export var fruit_curve: Curve
@export var fruit_scene: PackedScene
@export var sprite: EntitySprite2D
@export var fruit_sprite: EntitySprite2D

@export var fruit_jump_power: float = 130
@export var fruit_jump_power_variance: float = 30

var player: Player
var amount_of_fruit: int:
	set(value):
		amount_of_fruit = value
		if fruit_sprite:
			if amount_of_fruit == 0:
				fruit_sprite.visible = false
			else:
				fruit_sprite.visible = true
				fruit_sprite.frame = (amount_of_fruit - 1) if (amount_of_fruit < 3) else [2, 3].pick_random()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	amount_of_fruit = get_random_fruit_amount()
	if sprite:
		sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count(sprite.animation) - 1)
	body_entered.connect(on_player_entered)
	body_exited.connect(on_player_exited)

func get_random_fruit_amount() -> int:
	if fruit_curve:
		return int(fruit_curve.sample(randf()))
	
	return randi_range(0, 3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sprite:
		sprite.is_wobbling = !!player

func on_player_entered(node: Node2D) -> void:
	player = node as Player
	if player:
		player.movement_component.vector_scalar = .9

func on_player_exited(node: Node2D) -> void:
	if node as Player:
		player.movement_component.vector_scalar = 1
		player = null

func shear() -> void:
	for i in range(amount_of_fruit):
		var fruit: Fruit = fruit_scene.instantiate()
		fruit.position = position + Vector2.from_angle(randf() * 2 * PI) * 6
		fruit.movement_component.vector = Vector2.from_angle(randf() * 2 * PI) * (fruit_jump_power + randf() * fruit_jump_power_variance)
		add_sibling(fruit)
	queue_free()
