extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")

var player: Player2D = Player2D.new()
var tile_size: float = player.tile_size
@export var turns_to_move: int = 1

@export var tile_map: TileMapLayer = null
@export var player_node: CharacterBody2D = null
@export var line: Line2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var pathfinding_grid: AStarGrid2D = AStarGrid2D.new()
var path_to_player: Array[Vector2] = []
var turn_counter: int = 1

var last_known_player_cell: Vector2i = Vector2i(-999, -999)

func _ready() -> void:
	line.global_position = Vector2(tile_size / 2, tile_size / 2)
	pathfinding_grid.region = tile_map.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	
	pathfinding_grid.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	pathfinding_grid.offset = Vector2(0, 0) 
	pathfinding_grid.update()
	
	for cell in tile_map.get_used_cells():
		pathfinding_grid.set_point_solid(cell, false) 

func _physics_process(_delta: float) -> void:
	if not tile_map or not player_node:
		return

	var current_cell: Vector2i = tile_map.local_to_map(global_position)
	var player_cell: Vector2i = tile_map.local_to_map(player_node.global_position)
	
	if player_cell != last_known_player_cell:
		last_known_player_cell = player_cell
		_move_ai(current_cell, player_cell)

func _move_ai(current_cell: Vector2i, player_cell: Vector2i):
	path_to_player.assign(pathfinding_grid.get_point_path(current_cell, player_cell))
	line.points = path_to_player
	
	if turn_counter < turns_to_move:
		turn_counter += 1
	else:
		if path_to_player.size() > 1:
			var next_tile_position: Vector2 = path_to_player[1]
			var go_to_pos: Vector2 = next_tile_position + Vector2(tile_size / 2, tile_size / 2)
			
			if anim and go_to_pos.x != global_position.x:
				anim.flip_h = false if go_to_pos.x > global_position.x else true
			
			global_position = go_to_pos
			
			path_to_player.remove_at(0)
			line.points = path_to_player
			turn_counter = 1
