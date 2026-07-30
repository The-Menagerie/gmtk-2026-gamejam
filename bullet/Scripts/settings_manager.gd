extends Node

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "gameplay"
const SKIP_TUTORIAL_KEY := "skip_tutorial"
const CURSOR_HOTSPOT := Vector2(10, 10)

var reticle = load("res://Assets/Tilesets/StrangeCowboy/Player/reticle_norm.png")
var reticle_clicked = load("res://Assets/Tilesets/StrangeCowboy/Player/reticle_clicked.png")

var skip_tutorial := false

func _ready() -> void:
	load_settings()
	apply_custom_cursor()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_apply_cursor_texture(reticle_clicked if event.pressed else reticle)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func apply_custom_cursor() -> void:
	_apply_cursor_texture(reticle)
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _apply_cursor_texture(texture: Resource) -> void:
	Input.set_custom_mouse_cursor(texture, Input.CURSOR_ARROW, CURSOR_HOTSPOT)
	Input.set_custom_mouse_cursor(texture, Input.CURSOR_POINTING_HAND, CURSOR_HOTSPOT)
	Input.set_custom_mouse_cursor(texture, Input.CURSOR_FDIAGSIZE, CURSOR_HOTSPOT)

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
