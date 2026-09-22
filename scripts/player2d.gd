extends CharacterBody2D

const tile_size = 16

<<<<<<< HEAD
signal player_did_a_move
=======
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var map_layer: TileMapLayer = $"../TileMapLayer"
@onready var ladder_anim: AnimatedSprite2D = $"../ladder"
@onready var fade_out_anim: AnimatedSprite2D = $"../Fade_out"


var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var can_move: bool = false


func _ready() -> void:
	var current_cell = map_layer.local_to_map(position)
	var snapped_start_pos = map_layer.map_to_local(current_cell)
	position = snapped_start_pos
	target_position = snapped_start_pos
	can_move = true
	fade_out_anim.hide()
	fade_out_anim.animation = "hidden"

func _physics_process(delta: float) -> void:
	if is_moving:
		var behavior_speed = speed * 1.5
		position += (target_position - position) * behavior_speed * delta
		
		if position.distance_to(target_position) < 0.5:
			position = target_position
			is_moving = false
			
			var current_grid_pos = map_layer.local_to_map(position)
			# freeze if you is going into a ladder
			if cell_matches_id(current_grid_pos, "block_type", 2):
				can_move = false
				fade_out_anim.show()
				fade_out_anim.play("default")
				await fade_out_anim.animation_finished
				fade_out_anim.hide()
	else:
		move()


func move() -> void:
	if can_move:	
		var direction = get_input()
		var anim_direction = direction
		
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
					tile_data = cell_matches_id(next_grid_pos, "block_type", 2)
					if tile_data != null:
						if tile_data == true:
							if ladder_anim.animation == "closed":
								ladder_anim.play("opening")
							else:
								ladder()
						else:
							target_position = map_layer.map_to_local(next_grid_pos)
							is_moving = true
					else:
						target_position = map_layer.map_to_local(next_grid_pos)
						is_moving = true
			else:
				print("No tile painted here! Cannot walk into empty grid space.")
		
func get_input():
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
	
	return direction
	

func cell_matches_id(grid_pos: Vector2i, layer_name: String, target_id: int) -> bool:
	var tile_data: TileData = map_layer.get_cell_tile_data(grid_pos)

	if tile_data:
		var value = tile_data.get_custom_data(layer_name)
		if value != null:
			return int(value) == target_id

	return false
	var Position = position

func ladder():
	var direction = get_input()
	print("at ladder")
	var current_grid_pos = map_layer.local_to_map(position)
	var next_grid_pos = current_grid_pos + Vector2i(direction)
	target_position = map_layer.map_to_local(next_grid_pos)
	is_moving = true
	ladder_anim.animation = "opening"
	await ladder_anim.animation_finished
	ladder_anim.animation = "open"
>>>>>>> bf7ce064d6dacc646afa740d10116a944f153f4e
