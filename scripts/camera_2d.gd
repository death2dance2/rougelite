class_name RougeLikeCamera
extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 15.0

@onready var cell_template: AnimatedSprite2D = $UI_hp
const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()

var hp_cells: Array[AnimatedSprite2D] = []

func _ready() -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
	
	cell_template.hide()
	
	for i in range(player.max_health):
		var sprite_clone = cell_template.duplicate() as AnimatedSprite2D
		add_child(sprite_clone)
		
		sprite_clone.show()
		sprite_clone.position = Vector2(-3.752, -2.102)
		sprite_clone.position.x += i * 16
		hp_cells.append(sprite_clone)

func _process(delta: float) -> void:
	if target == null:
		return
		
	global_position = global_position.lerp(target.global_position, follow_speed * delta).round()
