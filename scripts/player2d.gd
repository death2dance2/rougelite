extends CharacterBody2D

const tile_size = 10

var direction = Vector2.ZERO
var speed = 30.0
var attack_power = 1
var anim_direction = Vector2.RIGHT
var sword_anim_direction = Vector2.ZERO
var sword_swing = false

@onready var anim = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var sword_anim = $sword_anim

func _ready() -> void:
	global_position = Vector2(5, 5)

func _physics_process(delta: float) -> void:
	direction = get_move_input()
	
	sword_anim_direction = get_attack_input()
	
	play_anim()
	
	var origin = global_position
	var target = global_position + (direction * tile_size)
	
	raycast.target_position = direction * tile_size * 0.3
	raycast.force_raycast_update()
	
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		if collider != null and collider.has_method("get_cell_tile_data"):
			var hit_point = raycast.get_collision_point()
			var map_position = collider.local_to_map(hit_point + direction * 2)
			var tile_data = collider.get_cell_tile_data(map_position)
			
			if tile_data != null:
				var tile_number = tile_data.get_custom_data("block_type")
				if tile_number == 1:
					print("you hit a wall!")
					return
					
		elif collider != null and collider.is_in_group("enemy"):
			pass

	if direction != Vector2.ZERO:
		global_position += direction * tile_size
	
	if sword_anim_direction != Vector2.ZERO:
			sword_swing = true
			animate_sword()

func get_move_input():
	if Input.is_action_just_pressed("move_right"):
		return Vector2.RIGHT
		
	elif Input.is_action_just_pressed("move_left"):
		return Vector2.LEFT
		
	elif Input.is_action_just_pressed("move_down"):
		return Vector2.DOWN
		
	elif Input.is_action_just_pressed("move_up"):
		return Vector2.UP
		
	return Vector2.ZERO
	
func get_attack_input():
	if Input.is_action_just_pressed("ui_up"):
		return Vector2.UP
	
	elif Input.is_action_just_pressed("ui_down"):
		return Vector2.DOWN
	
	elif Input.is_action_just_pressed("ui_left"):
		return Vector2.LEFT
	
	elif Input.is_action_just_pressed("ui_right"):
		return Vector2.RIGHT
	
	else:
		return Vector2.ZERO

func play_anim():
		
	if direction == Vector2.RIGHT:
		anim_direction = Vector2.RIGHT
	elif direction == Vector2.LEFT:
		anim_direction = Vector2.LEFT
	
	if anim_direction == Vector2.RIGHT:
		anim.flip_h = false
	else:
		anim.flip_h = true
		
	if direction * speed != Vector2(0, 0):
		anim.animation = "run"
	else:
		anim.animation = "idle"
		
func apply_damage(target: CharacterBody2D, damage: int):
	if target == null:
		return
	
	if "hp" in target:
		target.hp -= damage
		
	if target.has_method("die"):
		target.die()
	else:
		target.queue_free()
		
func animate_sword():
	if sword_swing == true:
		sword_swing = false
		sword_anim.global_position = global_position + (sword_anim_direction * tile_size)
		sword_anim.look_at(global_position + (sword_anim_direction * tile_size))
		print("sword attack!")
		sword_anim.play("slash")
		sword_anim_direction = Vector2.ZERO
