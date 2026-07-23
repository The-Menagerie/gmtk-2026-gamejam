extends Node2D

@export var current_level: Node
@export var anim_player: Node

func change_level(level: PackedScene) -> void:
	var new_level = level.instantiate()
	call_deferred("add_child",new_level)
	current_level.queue_free()
	current_level = new_level
	pass
