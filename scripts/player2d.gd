class_name Player2D
extends CharacterBody2D

@export var tile_size: float = 16
@export var speed: float = 200

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var map_layer: TileMapLayer = $"../TileMapLayer"

var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false


func _ready() -> void:
	var current_cell = map_layer.local_to_map(position)
	var snapped_start_pos = map_layer.map_to_local(current_cell)
	position = snapped_start_pos
	target_position = snapped_start_pos


func _physics_process(delta: float) -> void:
	if is_moving:
		position = position.lerp(target_position, speed * delta)
		
		if position.distance_to(target_position) < 1.0:
			position = target_position
			is_moving = false
		else:
			position = position.lerp(target_position, speed * delta)
	else:
		get_input()
		
func get_input() -> void:
	var direction := Vector2.ZERO
	
	# get input
	if Input.is_action_just_pressed("move_right"):
		direction = Vector2.RIGHT
			
	elif Input.is_action_just_pressed("move_left"):
		direction = Vector2.LEFT
			
	elif Input.is_action_just_pressed("move_down"):
		direction = Vector2.DOWN
			
	elif Input.is_action_just_pressed("move_up"):
		direction = Vector2.UP
		
	var anim_direction := direction
	
	# animate
	if anim_direction == Vector2.ZERO:
		if anim.animation == "left":
			anim.animation = "idle_left"
		else:
			if !anim.animation == "idle_left":
				anim.animation = "idle_right"
				
	if anim_direction == Vector2.LEFT:
		anim.animation = "left"
	elif anim_direction == Vector2.RIGHT:
		anim.animation = "right"

	if direction != Vector2.ZERO:
		var current_grid_pos = map_layer.local_to_map(position)
		var next_grid_pos = current_grid_pos + Vector2i(direction)
		var tile_data = cell_matches_id(next_grid_pos, "block_type", 1)
	
		if tile_data != null:
			if tile_data == true:
				print("movement blocked")
			else:
				target_position = map_layer.map_to_local(next_grid_pos)
				is_moving = true
		else:
			print("No tile painted here! Cannot walk into empty grid space.")

func cell_matches_id(grid_pos: Vector2i, layer_name: String, target_id: int) -> bool:
	var tile_data: TileData = map_layer.get_cell_tile_data(grid_pos)

	if tile_data:
		var value = tile_data.get_custom_data(layer_name)
		if value != null:
			return int(value) == target_id

	return false


	
	var Position = position
