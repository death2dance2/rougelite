extends AnimatedSprite2D

@onready var anim: AnimatedSprite2D = $"."

func _start() -> void:
	anim.visable = false
