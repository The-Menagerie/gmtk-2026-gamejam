extends Node2D

var reticle = load("res://Assets/Tilesets/StrangeCowboy/Player/reticle_norm.png")
var reticle_clicked = load("res://Assets/Tilesets/StrangeCowboy/Player/reticle_clicked.png")
var clicked = false

func _ready():
	Input.set_custom_mouse_cursor(reticle_clicked,Input.CURSOR_FDIAGSIZE,Vector2(20,20))
	Input.set_custom_mouse_cursor(reticle,Input.CURSOR_ARROW,Vector2(20,20))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			Input.set_default_cursor_shape(Input.CURSOR_FDIAGSIZE)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
