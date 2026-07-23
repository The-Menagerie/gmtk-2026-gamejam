extends Node2D

@export var current_level: Node
@export var anim_player: Node
@export_range(0.05, 1.0, 0.05) var bullet_time_scale: float = 0.35

var is_bullet_time_active := false
#@onready var score_label: Label = $CanvasLayer/ScoreLabel

#func _ready():
	#_update_score_label()

func _ready():
	Engine.time_scale = 1.0

func _process(_delta):
	_update_bullet_time()

func change_level(level: PackedScene) -> void:
	var new_level = level.instantiate()
	call_deferred("add_child",new_level)
	current_level.queue_free()
	current_level = new_level
	pass


func _update_bullet_time():
	var should_enable_bullet_time = Input.is_action_pressed("right_click")
	if should_enable_bullet_time == is_bullet_time_active:
		return

	is_bullet_time_active = should_enable_bullet_time
	Engine.time_scale = bullet_time_scale if is_bullet_time_active else 1.0


func _exit_tree():
	Engine.time_scale = 1.0
