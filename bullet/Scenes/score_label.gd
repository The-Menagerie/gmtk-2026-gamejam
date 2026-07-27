extends Label

var score: int = 0
var score_enabled := false
var popup_parent: Node
var has_initialized_run_score := false

const LOSS_POPUP_RISE_DISTANCE: float = 28.0
const LOSS_POPUP_DURATION: float = 0.7
const LOSS_POPUP_OFFSET: Vector2 = Vector2(24, 24)

func _ready() -> void:
	ScoreBus.score_update.connect(update_score)
	ScoreBus.score_loss_indicator.connect(show_score_loss_indicator)
	hide()
	text = "Score: %d" % score

	var game_manager := get_tree().root.find_child("MainGame", true, false)
	if game_manager != null and game_manager.has_signal("level_changed"):
		game_manager.level_changed.connect(_on_level_changed)
		_on_level_changed(game_manager.current_level.scene_file_path)

	popup_parent = get_parent()

func update_score(score_change: int) -> void:
	if not score_enabled:
		return

	score += score_change
	score = max(score, 0)
	text = "Score: %d" % score

func show_score_loss_indicator(amount: int) -> void:
	if not score_enabled or amount <= 0:
		return
	if popup_parent == null:
		return

	var popup: Label = Label.new()
	popup.text = "-%d" % amount
	popup.mouse_filter = Control.MOUSE_FILTER_IGNORE
	popup.z_index = 20
	popup.modulate = Color(1.0, 0.45, 0.35, 1.0)
	popup.position = position + LOSS_POPUP_OFFSET

	var popup_font: Font = get_theme_font("font")
	if popup_font != null:
		popup.add_theme_font_override("font", popup_font)
	popup.add_theme_font_size_override("font_size", get_theme_font_size("font_size"))

	popup_parent.add_child(popup)

	var tween: Tween = popup.create_tween()
	tween.set_parallel(true)
	tween.tween_property(popup, "position:y", popup.position.y + LOSS_POPUP_RISE_DISTANCE, LOSS_POPUP_DURATION)
	tween.tween_property(popup, "modulate:a", 0.0, LOSS_POPUP_DURATION)
	tween.chain().tween_callback(popup.queue_free)

func _on_level_changed(level_path: String) -> void:
	var level_name := level_path.get_file()

	if level_name == "lvl_01.tscn":
		if not has_initialized_run_score:
			score = ScoreBus.starting_score
			has_initialized_run_score = true
		score_enabled = true
		show()
		text = "Score: %d" % score
		return

	if level_name.begins_with("lvl_"):
		score_enabled = true
		show()
		text = "Score: %d" % score
		return

	score_enabled = false
	hide()
