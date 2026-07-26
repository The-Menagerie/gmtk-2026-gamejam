extends Label

var score: int = 0
var score_enabled := false

func _ready() -> void:
	ScoreBus.score_update.connect(update_score)
	hide()
	text = "Score: %d" % score

	var game_manager := get_tree().root.find_child("MainGame", true, false)
	if game_manager != null and game_manager.has_signal("level_changed"):
		game_manager.level_changed.connect(_on_level_changed)
		_on_level_changed(game_manager.current_level.scene_file_path)

func update_score(score_change: int) -> void:
	if not score_enabled:
		return

	score += score_change
	score = max(score, 0)
	text = "Score: %d" % score

func _on_level_changed(level_path: String) -> void:
	var level_name := level_path.get_file()

	if level_name == "lvl_01.tscn":
		score = ScoreBus.starting_score
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
