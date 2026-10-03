extends CharacterBody2D

@export var drops: Array[Dictionary] = [
	{
		"name": "gold",
		"min": 1,
		"max": 10,
		"rarity": 2
	}
]

@export var speed: float = 150.0
@export var max_health: float = 2
@export var health = 2
@export var action_queue: Array[String] = ["move", "move", "attack", "skip"]
var current_action_index: int = 0

@onready var anim = $AnimatedSprite2D
@onready var map_layer = $"../TileMapLayer"
@onready var player = $"../player"
@onready var raycast = $monster_raycast_2d
@onready var collision = $CollisionShape2D

var current_path: PackedVector2Array = []
var path_index: int = 0
var is_processing_action: bool = false
var actions_per_second = 0

func _ready():
	anim.play("idle")
	if health > max_health:
		health = max_health
	actions_per_second = player.actions_per_second
	execute_next_action()

func _physics_process(_delta):
	if not is_processing_action or action_queue[current_action_index] != "move":
		return

	if current_path.is_empty() or path_index >= current_path.size():
		finish_current_action()
		return
	
	var target_cell = current_path[path_index]
	var target_position = map_layer.map_to_local(target_cell) + map_layer.global_position
	
	var distance_to_target = global_position.distance_to(target_position)
	var move_distance = speed * _delta
	
	var origin = global_position
	var move_direction = global_position.direction_to(target_position)
	var target = global_position + (move_direction * move_distance)

	
	if global_position.distance_to(player.global_position) < (player.tile_size + (player.tile_size / 10)):
		path_index += 1
		return
	
	if move_distance >= distance_to_target:
		global_position = target_position
		velocity = Vector2.ZERO
		path_index += 1
	else:
		global_position = global_position + (global_position.direction_to(target_position) * player.tile_size)
		move_and_slide()

func execute_next_action():
	if player.global_position.x < global_position.x:
		anim.flip_h = true
	elif player.global_position.x > global_position.x:
		anim.flip_h = false
	
	if action_queue.is_empty():
		return
		
	is_processing_action = true
	var action = action_queue[current_action_index]

	match action:
		"move":
			calculate_path_to_next_tile()
		"attack":
			perform_attack_action()
		"skip":
			perform_skip_action()

func finish_current_action():
	print("AI moving")
	velocity = Vector2.ZERO
	is_processing_action = false
	current_action_index = (current_action_index + 1) % action_queue.size()
	var action_delay = 1.0 / actions_per_second
	await get_tree().create_timer(action_delay).timeout
	
	execute_next_action()


func calculate_path_to_next_tile():
	if not player or not map_layer.astar:
		finish_current_action()
		return
		
	var start_cell = map_layer.local_to_map(global_position)
	var end_cell = map_layer.local_to_map(player.global_position)
	var full_path = map_layer.astar.get_id_path(start_cell, end_cell)
	
	if full_path.size() > 1:
		current_path = [full_path[1]] 
		path_index = 0
	else:
		finish_current_action()

func perform_attack_action():
	if global_position.distance_to(player.global_position) < (player.tile_size + (player.tile_size / 10)):
		print("AI attacked the player!")
	else:
		print("AI swung but the player was too far away.")
		
	finish_current_action()

func perform_skip_action():
	print("AI skipped its turn.")
	finish_current_action()

func monster_take_damage(amount: int):
	health -= amount
	print("Monster took " + str(amount) + " damage")
	
	if health <= 0:
		die()

func die():
	print("die")
	anim.play("die")
	var drip = null
	var gold_drips = 0
	
	for i in range(len(drops)):
		if drops[i]["name"] == "gold":
			var possible_gold_drips = (randi() * drops[i]["max"])
			
			if possible_gold_drips >= drops[i]["min"]:
				possible_gold_drips = drops[i]["min"]
			
			gold_drips += possible_gold_drips
	
	player.inventory["gold"] += gold_drips

func _on_monster_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "sword_ollision":
		print("monster hit by the sword!")
		monster_take_damage(player.inventory["sword"])
