class_name breakable extends RigidBody2D

@export var fade_duration := 0.2
@export var crush_min_downward_speed := 5.0
@export var player_push_impulse := 4.0
@export var player_bottom_push_impulse := 3.0
@export var player_jump_bottom_push_impulse := 22.0
@export var player_jump_escape_time := 0.2

signal target_destroyed(target)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D2
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/CollisionShape2D

var is_dying := false

func _ready() -> void:
	add_to_group("crush_object")

func handle_death() -> void:
	if is_dying:
		return

	is_dying = true
	freeze = true
	_disable_collisions()
	target_destroyed.emit(self)

	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	await fade_tween.finished
	queue_free()

func can_crush_enemy() -> bool:
	return not is_dying and linear_velocity.y > crush_min_downward_speed

func push_by_player(push_direction: Vector2) -> void:
	if push_direction == Vector2.ZERO or is_dying:
		return

	var shove := push_direction.normalized()
	shove.y *= 0.15
	apply_central_impulse(shove.normalized() * player_push_impulse)

func push_from_below_by_player(push_direction: Vector2, player: PhysicsBody2D = null, jump_boost: bool = false) -> void:
	if is_dying:
		return

	var shove := push_direction
	if shove == Vector2.ZERO:
		shove = Vector2.LEFT

	shove = shove.normalized()
	if jump_boost:
		shove.x *= 0.35
		shove.y = -1.0
	else:
		shove.y = min(shove.y, -0.2)

	var impulse_strength = player_jump_bottom_push_impulse if jump_boost else player_bottom_push_impulse
	apply_central_impulse(shove.normalized() * impulse_strength)
	if jump_boost and is_instance_valid(player):
		add_collision_exception_with(player)
		_restore_player_collision(player)

func _restore_player_collision(player: PhysicsBody2D) -> void:
	await get_tree().create_timer(player_jump_escape_time).timeout
	if is_instance_valid(player):
		remove_collision_exception_with(player)

func _disable_collisions() -> void:
	if is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", true)

	if is_instance_valid(hitbox_collision):
		hitbox_collision.set_deferred("disabled", true)

	if is_instance_valid(hitbox_component):
		hitbox_component.set_deferred("monitoring", false)
		hitbox_component.set_deferred("monitorable", false)
