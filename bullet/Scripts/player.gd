extends CharacterBody2D

@export var move_speed : float = 200.0
@export var jump_force : float = 300.0
@export var gravity : float = 900.0
@export var starting_direction : float = 1.0

const BULLET_SCENE = preload("res://Scenes/Objects/Player/bullet.tscn")

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var revolver: Node2D = $Revolver

var facing_direction : float = 1.0

func _ready():
	animation_tree.active = true
	facing_direction = starting_direction if starting_direction != 0 else 1.0
	animation_tree.set("parameters/Idle/blend_position", facing_direction)
	animation_tree.set("parameters/Walk/blend_position", facing_direction)

func _physics_process(delta):
	var move_input = Input.get_axis("left", "right")
	var jump_pressed = Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")

	if jump_pressed and is_on_floor():
		velocity.y = -jump_force
	elif not is_on_floor():
		velocity.y += gravity * delta

	velocity.x = move_input * move_speed

	move_and_slide()
	update_animation_parameters()
	update_revolver_aim()
	fire_bullet()
	pick_new_state()

func update_animation_parameters():
	var mouse_position = get_global_mouse_position()
	var aim_vector = mouse_position - global_position
	if aim_vector.x != 0:
		facing_direction = 1.0 if aim_vector.x > 0 else -1.0
	animation_tree.set("parameters/Walk/blend_position", facing_direction)
	animation_tree.set("parameters/Idle/blend_position", facing_direction)
	animation_tree.set("parameters/Jump/blend_position", facing_direction)

func update_revolver_aim():
	var mouse_position = get_global_mouse_position()
	var aim_vector = mouse_position - global_position
	var angle = atan2(aim_vector.y, aim_vector.x)

	if aim_vector.x < 0:
		revolver.scale.x = -1.0
		revolver.rotation = angle - PI
	else:
		revolver.scale.x = 1.0
		revolver.rotation = angle

func fire_bullet():
	if Input.is_action_just_pressed("left_click"):
		var bullet = BULLET_SCENE.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = revolver.global_position
		bullet.add_collision_exception_with(self)
		var aim_vector = get_global_mouse_position() - global_position
		bullet.set_direction(aim_vector)

func pick_new_state():
	if not is_on_floor():
		state_machine.travel("Jump")
	elif abs(velocity.x) > 0.1:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
