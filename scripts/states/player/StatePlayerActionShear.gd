extends StatePlayerAction

@export var tool: Tool

var is_cutting: bool = true
	
func state_enter() -> void:
	super()
	tool.sprite.play("snip")
	tool.sprite.animation_finished.connect(on_animation_finished)
	var direction: Vector2 = Vector2.from_angle(so.tool_anchor.rotation)
	so.movement_component.is_sidescroller = false
	so.movement_component.target_vector = Vector2.ZERO
	so.movement_component.vector = direction * 150
	is_cutting = true

func state_exit() -> void:
	super()
	tool.sprite.animation_finished.disconnect(on_animation_finished)
	so.movement_component.is_sidescroller = true
	
func state_update(_delta: float) -> void:
	super(_delta)
	
func state_physics_update(_delta: float) -> void:
	if !is_cutting:
		super(_delta)
		
		if so.is_on_floor():
			goto_state("Grounded")
	else:
		so.movement_component.accelerate(_delta)
		so.movement_component.move_and_slide()
		animations()
		
		for node in tool.shear_hitbox.get_overlapping_areas():
			var bramble: Bramble = node as Bramble
			if bramble:
				(bramble).shear()
		
		so.regulate_jump()

func on_animation_finished() -> void:
	is_cutting = false
	so.movement_component.is_sidescroller = true
