extends Area2D

@export var cam_node: Node
@export var anim_player: Node

var camera_expanded := false

func _on_body_entered(body: Node2D) -> void:
	if camera_expanded == false:
		if body.is_in_group("player"):
			anim_player.play_section("expand_camera")
			pass
			
		
	pass # Replace with function body.
