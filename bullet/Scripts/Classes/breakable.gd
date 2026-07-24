class_name breakable extends RigidBody2D

@export var fade_duration := 0.2
@export var crush_min_downward_speed := 5.0
@export var player_push_impulse := 4.0
@export var player_bottom_push_impulse := 3.0

signal target_destroyed(target)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D2
@onready var hitbox_component: Area2D = $HitboxComponent
@onready var hitbox_collision: CollisionShape2D = $HitboxComponent/CollisionShape2D

var is_dying := false

func _ready() -> void:
	add_to_group("crush_object")
	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)

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

func push_from_below_by_player(push_direction: Vector2) -> void:
	if is_dying:
		return

	var shove := push_direction
	if shove == Vector2.ZERO:
		shove = Vector2.LEFT

	shove = shove.normalized()
	shove.y = min(shove.y, -0.2)
	apply_central_impulse(shove.normalized() * player_bottom_push_impulse)

func _on_body_entered(body: Node) -> void:
	if is_dying:
		return
	if not body.is_in_group("player"):
		return
	if linear_velocity.y <= crush_min_downward_speed:
		return
	if body.global_position.y <= global_position.y:
		return

	get_tree().reload_current_scene()

func _disable_collisions() -> void:
	if is_instance_valid(collision_shape):
		collision_shape.set_deferred("disabled", true)

	if is_instance_valid(hitbox_collision):
		hitbox_collision.set_deferred("disabled", true)

	if is_instance_valid(hitbox_component):
		hitbox_component.set_deferred("monitoring", false)
		hitbox_component.set_deferred("monitorable", false)
