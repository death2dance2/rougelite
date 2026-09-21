extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")

@export var monster_type: String = "basic statue"

var player: Player2D = Player2D.new()
var tile_size: float = player.tile_size
var current_path: Array[Vector2] = []
var speed = tile_size
var direction = Vector2.RIGHT

var stats = {
	"sight distance": 7,
	"damage": 1,
	"move delay": 0
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var tile_map: TileMapLayer = $"../TileMapLayer"
@onready var nav_agent: NavigationAgent2D = $NavAgent

func _ready() -> void:
	var pos = position
	anim.play("idle")
	if monster_type == "basic statue":
		stats["sight distance"] = 7
		stats["damage"] = 1
		stats["move delay"] = 0
		
	call_deferred("set_target_position", pos)

func set_target_position(target_pos: Vector2) -> void:
	nav_agent.target_position = target_pos

func _physics_process(delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	
	var raw_diff: Vector2 = next_path_position - current_agent_position
	var move_direction: Vector2 = Vector2.ZERO
	
	if abs(raw_diff.x) > abs(raw_diff.y):
		move_direction.x = sign(raw_diff.x)
	else:
		move_direction.y = sign(raw_diff.y)

	var distance: float = global_position.distance_to(nav_agent.target_position)
	
	velocity = move_direction * speed
	if distance > stats["sight distance"]:
		if move_direction.x < 0:
			if abs(move_direction.x) > 0:
				anim.play("run")
			elif abs(move_direction.y) > 0:
				anim.play("run")
			else:
				anim.play("still")
		
		if direction == Vector2.LEFT:
			anim.scale.x = -1
		else:
			anim.scale.x = 1
		
		move_and_slide()
