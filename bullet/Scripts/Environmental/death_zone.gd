extends Area2D

var scene_reset_queued := false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not scene_reset_queued:
			scene_reset_queued = true
			var game_manager := get_tree().root.find_child("MainGame", true, false)
			if game_manager != null and game_manager.has_method("reset_current_level"):
				game_manager.reset_current_level()
	pass # Replace with function body.
