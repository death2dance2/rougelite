extends CharacterBody2D

const tile_size = 10

var direction = Vector2.ZERO
var speed = 30.0
var attack_power = 1
var anim_direction = Vector2.RIGHT
var sword_anim_direction = Vector2.ZERO
var sword_swing = false
var is_attacking = false
var move = false
var is_busy = false
var health = 5

@onready var anim = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var sword_anim = $sword_anim
@onready var sword_collision = $sword_anim/CollisionShape2D

@export var actions_per_second: float = 2.5
@export var max_health: int = 5

@export var inventory: Dictionary = {
	"sword": 1,
	"gold": 5
}

func _ready() -> void:
	health = max_health
	global_position = Vector2(5, 5)

func _physics_process(delta: float) -> void:
	if is_busy:
		return
		
	if is_attacking == false:
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
				print("you hit an enemy!")
				return

		if direction != Vector2.ZERO && move == false:
			global_position += direction * tile_size
			finish_current_action()
			move = true
		
		if sword_anim_direction != Vector2.ZERO:
				sword_swing = true
				animate_sword()
				finish_current_action()
				

func get_move_input():
	if Input.is_action_pressed("move_right"):
		return Vector2.RIGHT
		
	elif Input.is_action_pressed("move_left"):
		return Vector2.LEFT
		
	elif Input.is_action_pressed("move_down"):
		return Vector2.DOWN
		
	elif Input.is_action_pressed("move_up"):
		return Vector2.UP
		
	return Vector2.ZERO
	
func get_attack_input():
	if Input.is_action_pressed("attack_up"):
		return Vector2.UP
	
	elif Input.is_action_pressed("attack_down"):
		return Vector2.DOWN
	
	elif Input.is_action_pressed("attack_left"):
		anim_direction = Vector2.LEFT
		return Vector2.LEFT
	
	elif Input.is_action_pressed("attack_right"):
		anim_direction = Vector2.RIGHT
		return Vector2.RIGHT
	
	else:
		return Vector2.ZERO

func play_anim():
	if is_attacking:
		return
		
	if direction == Vector2.RIGHT:
		anim_direction = Vector2.RIGHT
	elif direction == Vector2.LEFT:
		anim_direction = Vector2.LEFT
	
	if anim_direction == Vector2.RIGHT:
		anim.flip_h = false
	else:
		anim.flip_h = true
	
	move = false
	
	anim.play("idle")

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
	if sword_swing == true && is_attacking == false:
		sword_swing = false
		is_attacking = true
		
		sword_anim.global_position = global_position + (sword_anim_direction * tile_size)
		sword_collision.global_position = global_position + (sword_anim_direction * tile_size)
		sword_anim.rotation = 0
		var current_attack_direction = sword_anim_direction
		
		if sword_anim_direction == Vector2.LEFT:
			sword_anim.flip_h = true
			sword_anim.flip_v = false
			sword_anim.rotation = sword_anim_direction.angle() + (PI / 2)
			
		elif sword_anim_direction == Vector2.RIGHT:
			sword_anim.flip_h = false
			sword_anim.flip_v = false
			sword_anim.rotation = sword_anim_direction.angle() + (PI / 2)
			
		elif sword_anim_direction == Vector2.UP:
			sword_anim.flip_v = false
			
		elif sword_anim_direction == Vector2.DOWN:
			sword_anim.flip_v = true
			
		sword_anim_direction = Vector2.ZERO
		print("sword attack!")
		sword_anim.play("slash")
		anim.play("attack")
		await sword_anim.animation_finished
		sword_anim.animation = "nothing"
		is_attacking = false
		anim.animation = "idle"

func finish_current_action():
	is_busy = true
	var action_delay = 1.0 / actions_per_second
	await get_tree().create_timer(action_delay).timeout
	is_busy = false
