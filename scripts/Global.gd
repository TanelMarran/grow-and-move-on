extends Node

const RESTITUTION_GROUND: float = 300.0
const GRAVITY: float = 590.0
const GRAVITY_MAX: float = 120.0

var interactable: Array[PickupArea] = []
var valid_interactables: Array[PickupArea] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	valid_interactables = interactable.filter(func(interactable: PickupArea): return interactable.is_interactable)
