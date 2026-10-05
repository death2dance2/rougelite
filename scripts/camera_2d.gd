extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 15.0

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()

var hp_cells: Array[AnimatedSprite2D] = []

func _process(delta: float) -> void:
	if target == null:
		return
		
	global_position = global_position.lerp(target.global_position, follow_speed * delta).round()
