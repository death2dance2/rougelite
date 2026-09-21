extends CharacterBody2D

const Player2D = preload("res://scripts/player2d.gd")

@export var monster_type: String = "basic statue"

@onready var player = $"../player"
var player_script: Player2D = Player2D.new()
var tile_size: float = player_script.tile_size
var current_path: Array[Vector2] = []
var speed = tile_size
var direction = Vector2.RIGHT
var last_position = global_position

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

func find_target() -> void:
	set_target_position(player.global_position)

func _physics_process(delta: float) -> void:
	var last_position = global_position
	find_target()
	
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
		
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var current_agent_position: Vector2 = global_position
	var move_direction: Vector2 = (next_path_position - current_agent_position).normalized()
	velocity = move_direction * speed
	move_and_slide()
	
	if velocity.x != 0:
		anim.play("run")
		anim.flip_h = (velocity.x < 0)
	else:
		anim.play("idle")
	
	if global_position == last_position:
		anim.play("idle")
	
