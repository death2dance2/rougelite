extends Node2D

@export var glow_intensity_min: float = 1.5
@export var glow_intensity_max: float = 6.0
@export var glow_intensity_change_speed: float = 0.5
@export var detection_collision_layer: int = 1

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()
var side_distance: float = 16.0

@onready var anim: AnimatedSprite2D = $"."

var glow_intensity: float = glow_intensity_min + (glow_intensity_max - glow_intensity_min) * 0.5
var dimming: bool = false
var squares_list: Array[Node2D] = []

func _ready() -> void:
	var base_tile_size = 16.0
	if player and "tile_size" in player and player.tile_size > 0:
		base_tile_size = player.tile_size
	side_distance = base_tile_size * 1.0

	anim.animation = "nothing"
	if anim:
		squares_list.append(anim)
		setup_collision_for_square(anim, Vector2.ZERO)
	
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	for dir in directions:
		var side_square = Sprite2D.new()
		if anim and anim.sprite_frames:
			side_square.texture = anim.sprite_frames.get_frame_texture("not_highlighted", 0)
		
		add_child(side_square)
		side_square.position = dir * side_distance
		side_square.visible = false
		squares_list.append(side_square)
		setup_collision_for_square(side_square, dir * side_distance)

func _process(delta: float) -> void:
	if dimming:
		glow_intensity -= glow_intensity_change_speed * delta
		if glow_intensity <= glow_intensity_min:
			glow_intensity = glow_intensity_min
			dimming = false
	else:
		glow_intensity += glow_intensity_change_speed * delta
		if glow_intensity >= glow_intensity_max:
			glow_intensity = glow_intensity_max
			dimming = true
	
	update_all_glowing_squares(Color.WHITE)

func setup_collision_for_square(square: Node2D, local_pos: Vector2) -> void:
	var area = Area2D.new()
	area.collision_layer = 0
	area.collision_mask = detection_collision_layer
	add_child(area)
	area.position = local_pos
	
	var collision_shape = CollisionShape2D.new()
	var box = RectangleShape2D.new()
	box.size = Vector2(4.0, 4.0)
	collision_shape.shape = box
	area.add_child(collision_shape)
	
	area.area_entered.connect(func(_other_area): _on_square_triggered(square, true))
	area.area_exited.connect(func(_other_area): _on_square_triggered(square, false))
	area.body_shape_entered.connect(func(body_rid, body, _b, _l): _on_tile_triggered(square, body_rid, body, true))
	area.body_shape_exited.connect(func(body_rid, body, _b, _l): _on_tile_triggered(square, body_rid, body, false))

func _on_square_triggered(square: Node2D, is_touching: bool) -> void:
	if square is AnimatedSprite2D:
		square.animation = "not_highlighted" if is_touching else "nothing"
	elif square is Sprite2D:
		square.visible = is_touching

func _on_tile_triggered(square: Node2D, body_rid: RID, body: Node, is_touching: bool) -> void:
	var is_valid_wall = false
	if body is TileMapLayer:
		var tile_coords = body.get_coords_for_body_rid(body_rid)
		var tile_data = body.get_cell_tile_data(tile_coords)
		if tile_data and tile_data.get_custom_data("block_type") == 1:
			is_valid_wall = true
	elif body is TileMap:
		var tile_coords = body.get_coords_for_body_rid(body_rid)
		for layer in body.get_layers_count():
			var tile_data = body.get_cell_tile_data(layer, tile_coords)
			if tile_data and tile_data.get_custom_data("block_type") == 1:
				is_valid_wall = true
				break

	if is_valid_wall:
		_on_square_triggered(square, is_touching)

func update_all_glowing_squares(target_color: Color) -> void:
	var hdr_tint = Color(1.0, 1.0, 1.0, 1.0)
	hdr_tint.r = target_color.r * glow_intensity
	hdr_tint.g = target_color.g * glow_intensity
	hdr_tint.b = target_color.b * glow_intensity
	hdr_tint.a = target_color.a
	
	for square in squares_list:
		if is_instance_valid(square):
			square.modulate = hdr_tint
