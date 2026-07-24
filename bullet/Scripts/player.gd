extends CharacterBody2D

@export var move_speed : float = 200.0
@export var jump_force : float = 300.0
@export var gravity : float = 900.0
@export var starting_direction : float = 1.0
@export var revolver_rest_position : Vector2 = Vector2(0, 6)
@export var recoil_distance : float = 6.0
@export var recoil_return_speed : float = 22.0
@export var player_recoil_force : float = 260.0
@export var recoil_velocity_decay : float = 700.0
@export var vertical_recoil_scale : float = 0.45

const BULLET_SCENE = preload("res://Scenes/Objects/Bullets/bullet.tscn")

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]
@onready var revolver: Node2D = $Revolver
@onready var gunshot_audio: AudioStreamPlayer = $Revolver/AudioStreamPlayer

var facing_direction : float = 1.0
var recoil_offset : Vector2 = Vector2.ZERO
var recoil_velocity : Vector2 = Vector2.ZERO

func _ready():
	add_to_group("player")
	animation_tree.active = true
	facing_direction = starting_direction if starting_direction != 0 else 1.0
	animation_tree.set("parameters/Idle/blend_position", facing_direction)
	animation_tree.set("parameters/Walk/blend_position", facing_direction)
	revolver.position = revolver_rest_position
	BulletBus.fire_player_bullet.connect(fire_bullet)

func _physics_process(delta):
	var move_input = Input.get_axis("left", "right")
	var jump_pressed = Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")

	if jump_pressed and is_on_floor():
		velocity.y = -jump_force
	elif not is_on_floor():
		velocity.y += gravity * delta

	recoil_velocity = recoil_velocity.move_toward(Vector2.ZERO, recoil_velocity_decay * delta)
	velocity.x = move_input * move_speed + recoil_velocity.x
	velocity.y += recoil_velocity.y

	move_and_slide()
	update_animation_parameters()
	update_revolver_aim()
	update_revolver_recoil(delta)
	#fire_bullet()
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

	revolver.position = revolver_rest_position + recoil_offset

func update_revolver_recoil(delta):
	recoil_offset = recoil_offset.move_toward(Vector2.ZERO, recoil_return_speed * delta)

func fire_bullet(bullet_scene: PackedScene):
	#if Input.is_action_just_pressed("left_click"):
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.shooter = self
	bullet.global_position = revolver.global_position
	bullet.add_collision_exception_with(self)
	var aim_vector = get_global_mouse_position() - global_position
	bullet.set_direction(aim_vector)
	apply_revolver_kickback(aim_vector)
	if "recoil_multiplier" in bullet:
		apply_player_kickback(aim_vector, bullet.recoil_multiplier)
	else:
		apply_player_kickback(aim_vector)
	gunshot_audio.play()

func apply_revolver_kickback(aim_vector: Vector2):
	if aim_vector == Vector2.ZERO:
		return

	recoil_offset = -aim_vector.normalized() * recoil_distance

func apply_player_kickback(aim_vector: Vector2, recoil_multiplier: float = 1.0):
	if aim_vector == Vector2.ZERO:
		return

	var recoil_impulse = -aim_vector.normalized() * player_recoil_force * recoil_multiplier
	recoil_impulse.y *= vertical_recoil_scale
	recoil_velocity += recoil_impulse

func pick_new_state():
	if not is_on_floor():
		state_machine.travel("Jump")
	elif abs(velocity.x) > 0.1:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
