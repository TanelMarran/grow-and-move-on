class_name ToolDisplay extends TextureRect

@export var tool_texture_rect: TextureRect

func set_tool_texture(texture: Texture2D = null) -> void:
	if !texture:
		tool_texture_rect.visible = false
	else:
		tool_texture_rect.visible = true
		tool_texture_rect.texture = texture
