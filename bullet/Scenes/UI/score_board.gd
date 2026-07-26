extends Label

@export var reset_level: PackedScene

var score_label: Node

func _ready() -> void:
	var game_manager := get_tree().root.find_child("MainGame", true, false)
	var Canvas := game_manager.find_child("CanvasLayer", true, false)
	score_label = Canvas.find_child("ScoreLabel",true, false)
	
	self.text = str(score_label.score) + " Reputation"

func restart_button_pressed() -> void:
	$"../../../../WoodenBlock".play()
	await $"../../../../WoodenBlock".finished
	var game_manager := get_tree().root.find_child("MainGame", true, false)
	if game_manager != null and game_manager.has_method("change_level"):
		game_manager.change_level(reset_level)

func exit_button_pressed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	get_tree().quit()
