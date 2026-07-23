extends Label

var score: int = 1000

func _ready() -> void:
	ScoreBus.score_update.connect(update_score)

func update_score(score_change: int) -> void:
	score += score_change
	score = max(score, 0)
	text = "Score: %d" % score
