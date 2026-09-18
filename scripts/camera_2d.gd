class_name rouge_like_camera
extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 15.0

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()

func _ready() -> void:
	make_current()
	
	if not target:
		target = get_tree().get_first_node_in_group("player")
		
func _process(_delta: float) -> void:
	if target == null:
		return
		
	global_position = target.global_position.round()
