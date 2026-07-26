extends Label

var score_label: Node

func _ready() -> void:
	var game_manager := get_tree().root.find_child("MainGame", true, false)
	var Canvas := game_manager.find_child("CanvasLayer", true, false)
	score_label = Canvas.find_child("ScoreLabel",true, false)
	
	self.text = str(score_label.score) + " Reputation"
	
	
