extends Node2D

@export var drop_gravity : float = 900.0
@export var floor_snap_distance : float = 6.0
@export var muzzle_distance : float = 12.0

var drop_velocity : Vector2 = Vector2.ZERO
var is_dropping := false

const ENEMY_BULLET_SCENE = preload("res://Scenes/Objects/Enemies/EnemyBullet.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gunshot_audio: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	if is_instance_valid(animation_player):
		animation_player.play("Idle")

func _physics_process(delta):
	if not is_dropping:
		return

	drop_velocity.y += drop_gravity * delta
	var next_position = global_position + drop_velocity * delta
	var space_state = get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		next_position + Vector2(0.0, floor_snap_distance)
	)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)

	if not result.is_empty():
		global_position = result.position
		drop_velocity = Vector2.ZERO
		is_dropping = false
		return

	global_position = next_position

func drop(initial_velocity: Vector2 = Vector2.ZERO):
	drop_velocity = initial_velocity
	is_dropping = true

func fire(direction: Vector2, parent: Node):
	if is_dropping or parent == null or direction == Vector2.ZERO:
		return

	if is_instance_valid(animation_player) and animation_player.has_animation("Attack"):
		animation_player.play("Attack")

	if is_instance_valid(gunshot_audio):
		gunshot_audio.play()

	var bullet = ENEMY_BULLET_SCENE.instantiate()
	parent.add_child(bullet)
	bullet.global_position = global_position + direction.normalized() * muzzle_distance
	if bullet.has_method("set_direction"):
		bullet.set_direction(direction)
