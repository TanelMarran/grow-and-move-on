class_name PickupArea extends Area2D

var player: Player
var is_interactable: bool = true

signal picked_up(player: Player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(on_player_entered)
	body_exited.connect(on_player_exited)

func on_player_entered(node: Node2D) -> void:
	if node as Player:
		player = node
		Global.interactable.append(self)

func on_player_exited(node: Node2D) -> void:
	if node as Player:
		player = null
		Global.interactable.erase(self)

func pickup() -> void:
	picked_up.emit(player)
