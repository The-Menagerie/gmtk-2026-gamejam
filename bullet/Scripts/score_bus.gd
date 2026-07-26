extends Node

signal score_update(score_change) ##Positive score change value
signal score_loss_indicator(amount)

var starting_score: int = 77777
var score_per_shot: int = -500
var score_on_enemy_bullet_hit: int = -100
var score_on_spike_death: int = -500
var score_on_crush_death: int = -500
var passive_score_loss_per_second: int = 1

var _passive_score_timer: float = 0.0

func _process(delta: float) -> void:
	if passive_score_loss_per_second <= 0:
		return

	_passive_score_timer += delta

	while _passive_score_timer >= 1.0:
		_passive_score_timer -= 1.0
		apply_score_change(-passive_score_loss_per_second, false)

func reset_score() -> void:
	apply_score_change(starting_score, false)

func player_fired_shot() -> void:
	apply_score_change(score_per_shot)

func player_hit_by_enemy_bullet() -> void:
	apply_score_change(score_on_enemy_bullet_hit)

func player_died_to_spikes() -> void:
	apply_score_change(score_on_spike_death)

func player_died_to_crush() -> void:
	apply_score_change(score_on_crush_death)

func spend_score(amount: int) -> void:
	apply_score_change(-abs(amount))

func apply_score_change(score_change: int, show_loss_indicator: bool = true) -> void:
	score_update.emit(score_change)
	if show_loss_indicator and score_change < 0:
		score_loss_indicator.emit(abs(score_change))
