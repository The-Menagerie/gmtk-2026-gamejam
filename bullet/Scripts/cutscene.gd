extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var continue_button: Button = $Button
@onready var reveal_masks: Control = $RevealMasks

func _ready() -> void:
	if is_instance_valid(animation_player) and animation_player.has_animation("Cutscene"):
		animation_player.play("Cutscene")

	for child in reveal_masks.get_children():
		if child.has_method("start_reveal"):
			child.start_reveal()

	if is_instance_valid(continue_button) and not continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.connect(_on_continue_pressed)

func _on_continue_pressed() -> void:
	MusicManager.stop_music()
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")
