extends Control

func start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/newGame.tscn")

func options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/options.tscn")

func exit_button_pressed() -> void:
	get_tree().quit()

func back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/menu.tscn")
