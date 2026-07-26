extends Control

@onready var animation_player: AnimationPlayer = $ScreenAdjuster/AnimationPlayer
@onready var continue_button: Button = $ScreenAdjuster/Button
@onready var reveal_masks: Control = $ScreenAdjuster/RevealMasks
@onready var adjuster: Node2D = $ScreenAdjuster

var last_known_size = 1080

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
	

func _process(delta: float) -> void:
	if self.size.y != last_known_size:
		last_known_size = self.size.y
		print(last_known_size)
		var adjustment_distance = (self.size.y - last_known_size)/2
		adjuster.position.y += adjustment_distance
	
