extends CharacterBody2D

const tile_size = 10

var direction = Vector2.ZERO
var speed = 30.0
var attack_power = 1

@onready var raycast = $RayCast2D

func _ready() -> void:
	global_position = Vector2(5, 5)

func _physics_process(delta: float) -> void:
	direction = get_input()
	
	var origin = global_position
	var target = global_position + (direction * tile_size)
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		var hit_point = raycast.get_collision_point()
		var tile_data = collider.get_cell_tile_data(hit_point + (direction * 0.1))
		
		if tile_data != null:
			var tile_number = tile_data.get_custom_data("block_type")
				
			if tile_number == 1:
				print("you hit a wall!")
				return
			
		elif collider.is_in_group("enemy"):
			pass
	
	if direction != Vector2.ZERO:
		global_position += direction * tile_size

func get_input():
	if Input.is_action_just_pressed("move_right"):
		return Vector2.RIGHT
		
	elif Input.is_action_just_pressed("move_left"):
		return Vector2.LEFT
		
	elif Input.is_action_just_pressed("move_down"):
		return Vector2.DOWN
		
	elif Input.is_action_just_pressed("move_up"):
		return Vector2.UP
		
	return Vector2.ZERO

func apply_damage(target: CharacterBody2D, damage: int):
	if target == null:
		return
	
	if "hp" in target:
		target.hp -= damage
		
	if target.has_method("die"):
		target.die()
	else:
		target.queue_free()
