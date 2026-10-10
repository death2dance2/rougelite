extends AnimatedSprite2D

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()

@onready var anim: AnimatedSprite2D = $"."

func _ready() -> void:
	anim.stop()
	anim.animation = "default"

func _process(delta: float) -> void:
	var max = player.max_health
	var hp = player.health
	var selected_frame = 1
	
	selected_frame = max * max - max + hp
	
	anim.frame = selected_frame
	
	if Input.is_action_just_pressed("attack_down"):
		player.health -= 1
