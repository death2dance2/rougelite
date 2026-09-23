extends CharacterBody2D

const tile_size = 10

var direction = Vector2.ZERO
var speed = 30.0

func _ready() -> void:
	global_position = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	direction = get_input()
	
	if direction != Vector2.ZERO:
		global_position += direction * tile_size

func get_input():
	if Input.is_action_just_pressed("move_right"):
		return Vector2.RIGHT
		
	elif Input.is_action_just_pressed("move_left"):
		return Vector2.LEFT
		
	elif Input.is_action_just_pressed("move_down"):
		return Vector2.DOWN   # Fixed: Changed 'if' to 'return'
		
	elif Input.is_action_just_pressed("move_up"):
		return Vector2.UP     # Fixed: Changed 'if' to 'return'
		
	return Vector2.ZERO
