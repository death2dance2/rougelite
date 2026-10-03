class_name RougeLikeCamera
extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 15.0

@onready var hp_container = $UI_main
@onready var hp_template = $UI_hp

var hp_cells = []

func _ready() -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
	
	if target and "health" in target:
		make_cells(target.health)
	else:
		push_warning("Camera Target not found, or target does not have a 'health' variable!")
		make_cells(3)
		
	make_current()
	
	if hp_template:
		hp_template.hide()
		
func _process(delta: float) -> void:
	if target == null:
		return
		
	global_position = global_position.lerp(target.global_position, follow_speed * delta).round()

func make_cells(amount: int):
	for cell in hp_cells:
		if is_instance_valid(cell):
			cell.queue_free()
	hp_cells.clear()
	
	for i in range(amount):
		
		var cell_clone = hp_template.duplicate()
		cell_clone.show()	
		cell_clone.name = "cell_" + str(i)
		hp_container.add_child(cell_clone)
		hp_cells.append(cell_clone)
		
		cell_clone.animation = "max"
