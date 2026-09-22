extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")

var player: Player2D = Player2D.new()
var tile_size: float = player.tile_size
@export var turns_to_move: int = 1

@export var tile_map: TileMapLayer = null
@export var player_node: CharacterBody2D = null
@export var line: Line2D = null

var pathfinding_grid: AStar2D = AStar2D.new()
var path_to_player: Array = []
var turn_counter: int = 1

func _ready() -> void:
	line.global_position = Vector2(tile_size / 2, tile_size / 2)
	
	pathfinding_grid.reigon = tile_map.get_used_rect()
	pathfinding_grid.cell_size = Vector2(tile_size, tile_size)
	pathfinding_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	pathfinding_grid.update()
	
	for cell in pathfinding_grid.get_used_cells():
		pathfinding_grid.set_point_solid(cell, true)
		_move_ai()

func _move_ai():
	pass # you are here
