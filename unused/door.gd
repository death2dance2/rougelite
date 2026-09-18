extends AnimatedSprite2D

@onready var anim: AnimatedSprite2D = $"."
@onready var map_layer: TileMapLayer = $"../TileMapLayer"

func _ready() -> void:
	anim.animation = "door_down"
	_find_sprite_loop()
	
func _find_sprite_loop() -> void:
	if not map_layer:
		print("no valid map layer")
		return

	var used_cells = map_layer.get_used_cells()
	var found_target = false
	
	for cell in used_cells:
		var tile_data = map_layer.get_cell_tile_data(cell)
		if tile_data:
			var block_value = tile_data.get_custom_data("block_type")
			
			if block_value != null and int(block_value) == 4: 
				move_sprite_to_tile(anim, map_layer, cell)
				found_target = true
				break
				
	if not found_target:
		print("Could not find a door tile on the map layout")

func move_sprite_to_tile(sprite: Node2D, target_layer: TileMapLayer, tile_coords: Vector2i) -> void:
	if is_instance_valid(sprite) and target_layer:
		var local_pixel_pos = target_layer.map_to_local(tile_coords)
		sprite.global_position = target_layer.to_global(local_pixel_pos)
	else:
		print("no valid square")
		
	
func clone_myself():
	var clone = duplicate()
	get_parent().add_child(clone)
	clone.position += Vector2(6, 6)
