extends Node

func change_scene(target_path: String) -> void:
	call_deferred("_deferred_change_scene", target_path)

func _deferred_change_scene(target_path: String) -> void:
	var error = get_tree().change_scene_to_file(target_path)
	if error != OK:
		print("Failed to load scene at path: ", target_path)
	else:
		GameManager.change_scene(target_path)
