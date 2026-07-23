extends Control

signal show_pause()

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

func back_presed() -> void:
	$WoodenBlock.play()
	await $WoodenBlock.finished
	hide_options()
	show_pause.emit()
