extends Node
class_name HealthComponent

signal target_destroyed(target)

@export var MAX_HEALTH := 1.0
var health : float

func _ready():
	health = MAX_HEALTH

func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		target_destroyed.emit(self)
		get_parent().queue_free()
