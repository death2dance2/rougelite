extends TileMapLayer

var grid_map = []
var rooms = []

signal spawn_player(pos: Vector2)

@export var width = 10
@export var height = 15
@export var cell_size = 8
@export var min_room_size = 5
@export var max_room_size = 10
@export var max_rooms = 10

func _ready() -> void:
	generate_dungeon.call_deferred()

func generate_dungeon() -> void:
	clear()
	
	for x in range(width):
		for y in range(height):
			place_block(Vector2i(x, y), Vector2i(6, 3))
			
	var room_count = randi_range(5, max_rooms)
	var first_room_center = Vector2.ZERO
	
	for i in range(room_count):
		var room_w = randi_range(min_room_size, max_room_size)
		var room_h = randi_range(min_room_size, max_room_size)
		
		var start_x = randi_range(1, width - room_w - 1)
		var start_y = randi_range(1, height - room_h - 1)
		
		
		for x in range(start_x, start_x + room_w):
			for y in range(start_y, start_y + room_h):
				erase_cell(Vector2i(x, y * -1)) 
		
		if i == 1:
			first_room_center = Vector2(start_x + (room_w / 2.0), start_y + (room_h / 2.0))
		
	spawn_player.emit(first_room_center)
			
func place_block(block_position: Vector2i, spritemap_position: Vector2i):
	block_position.y *= -1
	if grid_map.has(block_position):
		erase_cell(block_position)
		grid_map.erase(block_position)
	else:
		set_cell(block_position, 1, spritemap_position, 0)

func check_block_at(grid_pos: Vector2i):
	if grid_map.has(grid_pos):
		print("Found a block here! Its source ID is: ", "10")
	else:
		print("This grid space is completely empty.")
	
