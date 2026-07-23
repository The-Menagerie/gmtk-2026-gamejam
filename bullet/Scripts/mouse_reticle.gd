extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(_delta):
	global_position = get_global_mouse_position()
	update_animation()

func update_animation():
	if Input.is_action_pressed("left_click"):
		animation_player.play("MouseDown")
	else:
		animation_player.play("MouseUp")
