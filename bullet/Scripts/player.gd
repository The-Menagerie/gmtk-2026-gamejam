extends CharacterBody2D

@export var move_speed : float = 100
@export var jump_force : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up")
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * move_speed
	
	move_and_slide()
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
		if(velocity != Vector2.ZERO):
			state_machine.travel("Walk")
		else:
			state_machine.travel("Idle")
