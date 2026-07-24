extends Node2D

signal picked_up(by: Node2D)

@export var pickup_group: StringName = &"player"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_area: Area2D = $PickupArea

var is_collected := false
var is_carried := false

func _ready() -> void:
	animation_player.play(&"Key")
	pickup_area.body_entered.connect(_on_body_entered)
	_update_pickup_state()

func _on_body_entered(body: Node2D) -> void:
	if is_collected:
		return
	if is_carried:
		return
	if not body.is_in_group(pickup_group):
		return

	is_collected = true
	if body.has_method("collect_key"):
		body.collect_key()
	picked_up.emit(body)
	queue_free()

func set_carried_state(carried: bool) -> void:
	is_carried = carried
	visible = not carried
	_update_pickup_state()

func drop_from_carrier() -> void:
	is_carried = false
	visible = true
	_update_pickup_state()

func _update_pickup_state() -> void:
	if is_instance_valid(pickup_area):
		pickup_area.set_deferred("monitoring", not is_carried)
		pickup_area.set_deferred("monitorable", not is_carried)
