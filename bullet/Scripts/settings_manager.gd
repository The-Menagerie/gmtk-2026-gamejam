extends Node

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "gameplay"
const SKIP_TUTORIAL_KEY := "skip_tutorial"

var skip_tutorial := false

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(SETTINGS_PATH)
	if err != OK:
		skip_tutorial = false
		return

	skip_tutorial = bool(config.get_value(SETTINGS_SECTION, SKIP_TUTORIAL_KEY, false))

func set_skip_tutorial(enabled: bool) -> void:
	if skip_tutorial == enabled:
		return

	skip_tutorial = enabled
	save_settings()

func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value(SETTINGS_SECTION, SKIP_TUTORIAL_KEY, skip_tutorial)
	config.save(SETTINGS_PATH)
