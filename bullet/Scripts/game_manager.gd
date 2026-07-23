extends Node2D

@export var current_level: Node
@export var anim_player: Node

var score: int = 1000

@onready var score_label: Label = $CanvasLayer/ScoreLabel

func _ready():
	_update_score_label()

func _process(_delta):
	_update_score_label()

func change_level(level: PackedScene) -> void:
	var new_level = level.instantiate()
	call_deferred("add_child",new_level)
	current_level.queue_free()
	current_level = new_level
	pass

func change_score(amount: int):
	score += amount
	score = max(score, 0)

func _update_score_label():
	if is_instance_valid(score_label):
		score_label.text = "Score: %d" % score
