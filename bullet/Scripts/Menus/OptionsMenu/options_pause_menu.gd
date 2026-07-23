extends Control

func _ready() -> void:
	hide()

func show_options() -> void:
	visible = true
	show()
	$AnimationPlayer.play("blur")
	await $AnimationPlayer.animation_finished

func hide_options() -> void:
	visible = false
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	hide()
