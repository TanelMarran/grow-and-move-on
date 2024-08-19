class_name UserInterface extends CanvasLayer

@export var game_end_prompt: Control
@export var water_bar: ResourceBar
var _game_end_prompt_visible: bool = false
var _game_end_prompt_tween: Tween
var _game_end_propt_home_pos: Vector2
signal game_end_prompt_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("control_ready")

func control_ready() -> void:
	_game_end_propt_home_pos = game_end_prompt.position
	toggle_game_end_prompt(false, true)

func toggle_game_end_prompt(node_visible: bool, instant: bool = false) -> void:
	if _game_end_prompt_tween:
		_game_end_prompt_tween.kill()
	
	_game_end_prompt_tween = get_tree().create_tween()
	_game_end_prompt_tween.set_trans(Tween.TRANS_QUAD)
	_game_end_prompt_tween.finished.connect(func():
		game_end_prompt_finished.emit()
	, CONNECT_ONE_SHOT)
	
	var move_amount: float = game_end_prompt.size.y * 2 + 16
	var duration: float = 0 if instant else 1.2
	if node_visible:
		_game_end_prompt_tween.tween_property(game_end_prompt, "position", _game_end_propt_home_pos, duration)
	else:
		_game_end_prompt_tween.tween_property(game_end_prompt, "position", _game_end_propt_home_pos + Vector2.DOWN * move_amount, duration)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
