class_name Store extends Sprite2D

@export var pickup_area: PickupArea
@export var seed_anchor: EntitySprite2D
@export var lootpools: Array[Lootpool]
@export var price: int = 3

var current_seed: Seed:
	set(value):
		current_seed = value
		if !value:
			seed_anchor.sprite_frames = null

func _ready() -> void:
	Global.player.fruit_picked_up.connect(on_fruit_pickup)
	Global.player.fruit_used.connect(on_fruit_used)
	pickup_area.picked_up.connect(on_bought)
	pickup_area.is_interactable = price <= Global.player.fruit_amount && current_seed
	restock()
	
func restock():
	current_seed = Lootpool.select_random_scene(lootpools).instantiate()
	seed_anchor.sprite_frames = current_seed.sprite.sprite_frames
	seed_anchor.animation = "seed"
	
func on_fruit_pickup() -> void:
	pickup_area.is_interactable = price <= Global.player.fruit_amount && current_seed
	
func on_fruit_used(amount: int) -> void:
	pickup_area.is_interactable = price <= Global.player.fruit_amount && current_seed
	
func on_bought(player: Player) -> void:
	if current_seed:
		add_sibling(current_seed)
		current_seed.picked_up(player)
		current_seed = null
		player.fruit_amount -= price
		get_tree().create_timer(1).timeout.connect(restock, CONNECT_ONE_SHOT)
