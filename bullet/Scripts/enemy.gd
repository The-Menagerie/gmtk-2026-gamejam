extends CharacterBody2D

@export var gravity : float = 900.0

signal target_destroyed(target)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
