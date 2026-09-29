extends TileMapLayer

var astar = AStarGrid2D.new()

func _ready():
	var map_limits = get_used_rect()
	astar.region = map_limits
	astar.cell_size = tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()

	for cell in get_used_cells():
		var tile_data = get_cell_tile_data(cell)
		if tile_data:
			var solid = tile_data.get_custom_data("block_type")
			var tile_weight = tile_data.get_custom_data("weight")
			
			if solid == 1:
				astar.set_point_solid(cell, true)
			if tile_weight > 0:
				astar.set_point_weight_scale(cell, tile_weight)
