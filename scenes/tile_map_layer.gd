extends TileMapLayer

const SOURCE_ID: int = 0

var map_layout: Array = [
	[1, 1, 1, 1, 1]
]

var astar_grid: AStarGrid2D

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(0, 0, map_layout[0].size(), map_layout.size())
	astar_grid.cell_size = Vector2(32, 32)
	astar_grid.update()
	
	build_level_nodes()

func build_level_nodes() -> void:
	for y in range(map_layout.size()):
		for x in range(map_layout[y].size()):
			var cell_coords = Vector2i(x, y)
			var tile_id = map_layout[y][x]
			
			var atlas_coords = get_atlas_coords_for_id(tile_id)
			
			set_cell(cell_coords, SOURCE_ID, atlas_coords)
			
			if tile_id == 1 or tile_id == 2:
				astar_grid.set_point_solid(cell_coords, true)
			else:
				astar_grid.set_point_solid(cell_coords, false)

func get_atlas_coords_for_id(id: int) -> Vector2i:
	match id:
		0: return Vector2i(0, 0)
		1: return Vector2i(1, 0)
		2: return Vector2i(2, 0)
		_: return Vector2i(-1, -1)
