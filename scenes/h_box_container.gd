extends AnimatedSprite2D

const Player2D = preload("res://scripts/player2d.gd")
var player: Player2D = Player2D.new()

var last_hp = player.health
var current_hp = player.health

var hp_cells: Dictionary = {
	"1": {"id": 1, "sprite": null},
	"2": {"id": 1, "sprite": null},
	"3": {"id": 1, "sprite": null},
	"4": {"id": 1, "sprite": null},
	"5": {"id": 1, "sprite": null},
	"6": {"id": 1, "sprite": null},
	"7": {"id": 1, "sprite": null}
}

func _ready() -> void:
	hp_cells["1"]["sprite"] = $hp_1
	hp_cells["2"]["sprite"] = $hp_2
	hp_cells["3"]["sprite"] = $hp_3
	hp_cells["4"]["sprite"] = $hp_4
	hp_cells["5"]["sprite"] = $hp_5
	hp_cells["6"]["sprite"] = $hp_6
	hp_cells["7"]["sprite"] = $hp_7
	
	last_hp = player.health
	current_hp = player.health

func _process(delta: float) -> void:
	last_hp = current_hp
	current_hp = player.health
	
	for j in range(1, len(hp_cells) + 1):
		var current_sprite = hp_cells[str(j)]["sprite"]
		if j <= current_hp:
			current_sprite.play("max")
			
		elif j > player.max_health:
			current_sprite.play("empty")
			
		elif j > current_hp:
			current_sprite.play("none")
	
	for i in range(len(hp_cells)):
		var cell = hp_cells.get(str(i))
		if cell and cell.get("id") == 1:
			pass
