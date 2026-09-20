extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()
var tile_size: float = player.tile_size
var current_path: Array[Vector2] = []
var speed = tile_size
var direction = Vector2.RIGHT
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_map: TileMapLayer = $"../TileMapLayer"

func ready() -> void:
	anim.play("idle")
