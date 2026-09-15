extends Node2D

@export var glow_intensity_min: float = 1.5
@export var glow_intensity_max: float = 6.0
@export var glow_intensity_change_speed: float = 5.0
const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()
var side_distance: float = player.tile_size

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var glow_intensity: float = glow_intensity_min + (glow_intensity_max - glow_intensity_min) * 0.5
var dimming: bool = false
var squares_list: Array[Node2D] = []

func _ready() -> void:
	if anim:
		squares_list.append(anim)
		
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	
	for dir in directions:
		var side_square = Sprite2D.new()
		
		if anim and anim.sprite_frames:
			side_square.texture = anim.sprite_frames.get_frame_texture(anim.animation, 0)
			
		add_child(side_square)
		side_square.position = dir * side_distance
		squares_list.append(side_square)

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

func update_all_glowing_squares(target_color: Color) -> void:
	var hdr_tint = Color()
	hdr_tint.r = target_color.r * glow_intensity
	hdr_tint.g = target_color.g * glow_intensity
	hdr_tint.b = target_color.b * glow_intensity
	hdr_tint.a = target_color.a
	
	for square in squares_list:
		if is_instance_valid(square):
			square.modulate = hdr_tint
