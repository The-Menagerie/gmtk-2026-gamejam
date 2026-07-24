extends CharacterBody2D

@export var speed : float = 500.0
@export var damage : float = 10.0
@export var max_bounces : int = 3
@export var knock_back: float = 15.0
@export var recoil_multiplier: float = 1.0

var direction : Vector2 = Vector2.RIGHT
var area_2d: Area2D
var bounce_count : int = 0
var shooter: Node

@onready var ricochet_audio: AudioStreamPlayer = $RicochetAudio

func _ready():
	area_2d = $Area2D
	area_2d.area_entered.connect(_on_area_entered)
	area_2d.add_to_group("bullet")

func _physics_process(delta):
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if _try_damage_collider(collision.get_collider()):
			#queue_free()
			pass
		if bounce_count >= max_bounces:
			queue_free()
			return
		bounce_count += 1
		direction = direction.bounce(collision.get_normal()).normalized()
		rotation = direction.angle()
		ricochet_audio.play()

func _on_area_entered(area: Area2D):
	if _try_damage_hitbox(area):
		pass
		#queue_free()

func set_direction(new_direction: Vector2):
	direction = new_direction.normalized()
	rotation = direction.angle()
	#print("Bullet velocity set to: "+str(direction))

func _try_damage_collider(collider: Node) -> bool:
	if collider is Area2D:
		return _try_damage_hitbox(collider)

	for child in collider.get_children():
		if child is Area2D and _try_damage_hitbox(child):
			return true

	return false

func _try_damage_hitbox(area: Area2D) -> bool:
	if not area.is_in_group("hitbox"):
		return false

	var knock_back_target = area.get_parent()
	if knock_back_target is CharacterBody2D:
		var kb_timer = knock_back_target.find_child("HitTimer")
		#print(kb_timer.is_stopped())
		if kb_timer.is_stopped():
			#print(direction)
			knock_back_target.velocity.x += direction.x*knock_back
			knock_back_target.velocity.y += direction.y*knock_back
			#print("New velocity is " + str(knock_back_target.velocity))
			knock_back_target.knockedback = true
			kb_timer.start()
	
	
	var attack = Attack.new()
	attack.attack_damage = damage
	area.damage(attack)
	return true
