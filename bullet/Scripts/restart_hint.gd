extends Label

@export_range(0.05, 1.0, 0.05) var fade_duration: float = 0.25

var fade_tween: Tween
var is_allowed_in_level := false

func _ready() -> void:
	modulate.a = 0.0
	hide()
	BulletBus.out_of_ammo_changed.connect(_on_out_of_ammo_changed)
	var game_manager := get_tree().root.find_child("MainGame", true, false)
	if game_manager != null and game_manager.has_signal("level_changed"):
		game_manager.level_changed.connect(_on_level_changed)
		_on_level_changed(game_manager.current_level.scene_file_path)

func _on_out_of_ammo_changed(is_out_of_ammo: bool) -> void:
	if not is_allowed_in_level:
		_hide_immediately()
		return

	if fade_tween != null and fade_tween.is_valid():
		fade_tween.kill()

	show()
	fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 1.0 if is_out_of_ammo else 0.0, fade_duration)
	if not is_out_of_ammo:
		fade_tween.finished.connect(hide)

func _on_level_changed(level_path: String) -> void:
	var level_name := level_path.get_file()
	is_allowed_in_level = not level_name.begins_with("tut_")
	if not is_allowed_in_level:
		_hide_immediately()

func _hide_immediately() -> void:
	if fade_tween != null and fade_tween.is_valid():
		fade_tween.kill()
	modulate.a = 0.0
	hide()
