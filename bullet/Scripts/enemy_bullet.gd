extends CharacterBody2D

@export var speed : float = 320.0
@export var lifetime : float = 2.5
@export var score_damage : int = 100

const RICOCHET_SOUND = preload("res://Assets/SoundEffects/ricochet.wav")

var direction : Vector2 = Vector2.RIGHT
var time_alive : float = 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	add_to_group("enemy_projectile")
	if is_instance_valid(animation_player) and animation_player.has_animation("Spin"):
		animation_player.play("Spin")

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		_handle_hit(collision.get_collider())
		queue_free()
		return

	rotation = direction.angle()
	time_alive += delta

	if time_alive >= lifetime:
		queue_free()

func set_direction(new_direction: Vector2):
	if new_direction == Vector2.ZERO:
		return

	direction = new_direction.normalized()
	rotation = direction.angle()

func _handle_hit(collider: Object):
	if collider == null:
		_play_ricochet()
		return

	var hit_node := collider as Node
	if hit_node == null:
		_play_ricochet()
		return

	if hit_node.is_in_group("player"):
		_apply_score_damage()
		return

	var parent = hit_node.get_parent()
	if parent != null and parent.is_in_group("player"):
		_apply_score_damage()
		return

	_play_ricochet()

func _apply_score_damage():
	ScoreBus.score_update.emit(-score_damage)
	#var game_manager = get_tree().root.find_child("MainGame", true, false)
	#if game_manager != null and game_manager.has_method("change_score"):
		#game_manager.change_score(-score_damage)

func _play_ricochet():
	var parent = get_parent()
	if parent == null:
		return

	var ricochet_audio := AudioStreamPlayer.new()
	ricochet_audio.stream = RICOCHET_SOUND
	ricochet_audio.bus = "Master"
	parent.add_child(ricochet_audio)
	ricochet_audio.finished.connect(ricochet_audio.queue_free)
	ricochet_audio.play()
