extends RigidBody2D

@export var attack_damage := 999.0
@export var attack_height_margin := 6.0
@export var bullet_knockback := 35.0
@export var player_push_impulse := 4.0
@export var player_bottom_push_impulse := 3.0
@export var player_jump_bottom_push_impulse := 22.0
@export var player_jump_escape_time := 0.2

@onready var attack_area: Area2D = $AttackArea

func _ready() -> void:
	attack_area.area_entered.connect(_on_attack_area_entered)

func _physics_process(_delta: float) -> void:
	_check_fall_attack_overlaps()

func _on_attack_area_entered(area: Area2D) -> void:
	_try_fall_attack(area)

func _check_fall_attack_overlaps() -> void:
	for area in attack_area.get_overlapping_areas():
		_try_fall_attack(area)

func _try_fall_attack(area: Area2D) -> void:
	if linear_velocity.y <= 0.0:
		return
	if not area.is_in_group("hitbox"):
		return
	if area.global_position.y <= global_position.y + attack_height_margin:
		return

	var attack := Attack.new()
	attack.attack_damage = attack_damage
	area.damage(attack)

func apply_bullet_knockback(hit_direction: Vector2) -> void:
	if hit_direction == Vector2.ZERO:
		return

	# Keep the nudge subtle and mostly horizontal so shots can free the player
	# without launching the boulder around.
	var knockback_direction := hit_direction.normalized()
	knockback_direction.y *= 0.2
	apply_central_impulse(knockback_direction.normalized() * bullet_knockback)

func push_by_player(push_direction: Vector2) -> void:
	if push_direction == Vector2.ZERO:
		return

	var shove := push_direction.normalized()
	shove.y *= 0.15
	apply_central_impulse(shove.normalized() * player_push_impulse)

func push_from_below_by_player(push_direction: Vector2, player: PhysicsBody2D = null, jump_boost: bool = false) -> void:
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
