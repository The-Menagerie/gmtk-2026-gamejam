extends Node

signal score_update(score_change) ##Positive score change value

var starting_score: int = 77777
var score_per_shot: int = -500
var score_on_enemy_bullet_hit: int = -100
var score_on_spike_death: int = -500
var passive_score_loss_per_second: int = 1

var _passive_score_timer: float = 0.0

func _process(delta: float) -> void:
	if passive_score_loss_per_second <= 0:
		return

	_passive_score_timer += delta

	while _passive_score_timer >= 1.0:
		_passive_score_timer -= 1.0
		score_update.emit(-passive_score_loss_per_second)

func reset_score() -> void:
	score_update.emit(starting_score)

func player_fired_shot() -> void:
	score_update.emit(score_per_shot)

func player_hit_by_enemy_bullet() -> void:
	score_update.emit(score_on_enemy_bullet_hit)

func player_died_to_spikes() -> void:
	score_update.emit(score_on_spike_death)
