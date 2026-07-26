extends Node2D

signal level_changed(level_path: String)

@export var current_level: Node
@export var anim_player: Node
@export_range(0.05, 1.0, 0.05) var bullet_time_scale: float = 0.35

var is_bullet_time_active := false
var is_level_reset_queued := false
#@onready var score_label: Label = $CanvasLayer/ScoreLabel

#func _ready():
	#_update_score_label()

func _ready():
	Engine.time_scale = 1.0
	_emit_level_changed()

func _process(_delta):
	_update_bullet_time()

func change_level(level: PackedScene) -> void:
	var new_level = level.instantiate()
	call_deferred("add_child",new_level)
	current_level.queue_free()
	current_level = new_level
	call_deferred("_emit_level_changed")

func reset_current_level() -> void:
	if is_level_reset_queued:
		return
	if current_level == null:
		return
	if current_level.scene_file_path.is_empty():
		return

	is_level_reset_queued = true
	call_deferred("_deferred_reset_current_level")

func _deferred_reset_current_level() -> void:
	if current_level == null:
		is_level_reset_queued = false
		return

	var level_scene := load(current_level.scene_file_path) as PackedScene
	if level_scene == null:
		is_level_reset_queued = false
		return

	var new_level := level_scene.instantiate()
	add_child(new_level)
	current_level.queue_free()
	current_level = new_level
	is_level_reset_queued = false
	_emit_level_changed()


func _update_bullet_time():
	var should_enable_bullet_time = Input.is_action_pressed("right_click") or Input.is_action_pressed("bullet_time")
	if should_enable_bullet_time == is_bullet_time_active:
		return

	is_bullet_time_active = should_enable_bullet_time
	Engine.time_scale = bullet_time_scale if is_bullet_time_active else 1.0


func _exit_tree():
	Engine.time_scale = 1.0

func _emit_level_changed() -> void:
	if current_level == null:
		return

	level_changed.emit(current_level.scene_file_path)
