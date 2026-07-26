extends Control

@onready var menu_music: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if is_instance_valid(menu_music):
		menu_music.finished.connect(_on_menu_music_finished)
		if not menu_music.playing:
			menu_music.play()

func start_button_pressed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func options_button_pressed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/options.tscn")

func exit_button_pressed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	get_tree().quit()

func back_button_pressed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/menu.tscn")

func _on_menu_music_finished() -> void:
	if is_instance_valid(menu_music):
		menu_music.play()
