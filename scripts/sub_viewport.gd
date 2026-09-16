extends SubViewport

@export var target_render_width: int = 320
@export var target_render_height: int = 180

func _ready():
	size = Vector2i(target_render_width, target_render_height)
	
	size_2d_override_stretch = true
	
	var container = get_parent()
	if container is SubViewportContainer:
		container.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
