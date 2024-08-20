extends Node2D

@export_range(0, 100, 1.1) var chance_of_fruit: float = 33
@export var frequency: float = 60 * 2
@export var frequency_variance: float = 30
@export var birds: Array[Bird]
@export var loot_pools: Array[Lootpool]
@onready var _birdstrike_timer: float = get_random_birdstrike_time()

@export_group("Range")
@export var birdstrike_y_min: float = -600
@export var birdstrike_y_max: float = -100
@export var birdstrike_x_min: float = -180
@export var birdstrike_x_max: float = 180
@export var birdstrike_ground_ray_density: float = 18
@export var birdstrike_ground_ray_length: float = 300
@export_flags_2d_physics var birdstrike_ground_ray_mask: int = pow(2, 0)

const BIRDSTRIKE_HEIGHT: float = 160

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_birdstrike_timer -= delta
	if _birdstrike_timer <= 0:
		birdstrike()
		_birdstrike_timer = get_random_birdstrike_time()
	
func get_random_birdstrike_time() -> float:
	return frequency + randf_range(-1, 1) * frequency_variance

func birdstrike() -> void:
	var player: Player = Global.player
	var random_y_min: float = max(birdstrike_y_min, player.global_position.y - BIRDSTRIKE_HEIGHT)
	var random_y_max: float = min(birdstrike_y_max, player.global_position.y + BIRDSTRIKE_HEIGHT)
	var with_fruit: bool = randf() * 100 < chance_of_fruit
	if random_y_min < random_y_max:
		var random_y: float = random_y_min + randf() * (random_y_max - random_y_min)
		var random_x: float = get_random_drop_x(random_y)
		var random_item: PackedScene = Lootpool.select_random_scene(loot_pools) if with_fruit else null
		
		for bird in birds:
			if !bird.is_flying():
				if random_item:
					bird.hold_seed(random_item.instantiate() as Seed)
				bird.fly_and_drop(Vector2(random_x, random_y), randf() > .5)
				break

func get_random_drop_x(drop_y: float) -> float:
	var world_space: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var current_x: float = birdstrike_x_min
	var possible_x_values: Array[float] = []
	while current_x < birdstrike_x_max:
		var params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.new()
		params.collision_mask = birdstrike_ground_ray_mask
		params.from = Vector2(current_x, drop_y)
		params.to = params.from + Vector2.DOWN * birdstrike_ground_ray_length
		var result: Dictionary = world_space.intersect_ray(params)
		if result.has("position"):
			possible_x_values.append(result["position"].x)
		current_x += birdstrike_ground_ray_density
		
	if possible_x_values.size() > 0:
		return possible_x_values.pick_random()
		
	return randf_range(birdstrike_x_min, birdstrike_x_min)
