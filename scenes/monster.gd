extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()
var tile_size: float = player.tile_size

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var target_position: Vector2 = Vector2.ZERO
var is_moving: bool = false
var can_move: bool = false

func _ready() -> void:
	pass
