class_name LevelRoot extends Node2D

@export var targets: Array[Node]
@export var next_level: PackedScene
var num_targets
var game_manager
var has_targets = false
var targets_left

func _ready() -> void:
	game_manager = get_parent()
	num_targets = targets.size()
	if num_targets > 0:
		has_targets = true
		targets_left = num_targets
		
		for t in targets:
			t.target_destroyed.connect(target_down)


func target_down(target:Node) -> void:
	targets_left -= 1
	var target_index = targets.find(target)
	targets.remove_at(target_index)
	if targets_left <= 0:
		game_manager.change_level(next_level)
		
		
