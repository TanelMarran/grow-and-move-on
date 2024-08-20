class_name Lootpool extends Resource

@export var weight: int = 1
@export var scenes: Array[PackedScene]

static func select_random_scene(lootpools: Array[Lootpool]) -> PackedScene:
	var total_points: int = lootpools.reduce(func(a: int, b: Lootpool) -> int: return a + b.weight, 0)
	var random_pool_point: int = randi_range(0, total_points - 1)
	var selected_pool: Lootpool = null
	var acc: int = 0
	for pool in lootpools:
		if acc <= random_pool_point && random_pool_point < acc + pool.weight:
			selected_pool = pool
			break
		else:
			acc += pool.weight
	
	return selected_pool.scenes.pick_random()
