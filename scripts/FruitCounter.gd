class_name FruitCounter extends HBoxContainer

@export var increase_speed: float = 15
@export var label: Label
var target_fruit: float = 0
var label_fruit: float = 0:
	set(value):
		label_fruit = value
		if label:
			label.text = str(int(ceil(value)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label_fruit = max(target_fruit, label_fruit + (target_fruit - label_fruit) * delta * increase_speed)
