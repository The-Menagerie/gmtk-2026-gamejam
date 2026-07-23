extends CharacterBody2D

@export var speed : float = 500.0
@export var damage : float = 10.0
@export var max_bounces : int = 3

var direction : Vector2 = Vector2.RIGHT
var area_2d: Area2D
var bounce_count : int = 0

func _ready():
	area_2d = $Area2D
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.add_to_group("bullet")

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if bounce_count >= max_bounces:
			queue_free()
			return
		bounce_count += 1
		direction = direction.bounce(collision.get_normal()).normalized()
		rotation = direction.angle()

func _on_area_entered(area: Area2D):
	if area.is_in_group("hitbox"):
		var attack = Attack.new()
		attack.attack_damage = damage
		area.damage(attack)
		queue_free()

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()
	rotation = direction.angle()
