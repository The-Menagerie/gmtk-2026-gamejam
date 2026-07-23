extends Control

enum BULLET_TYPE {REGULAR = 1, SAD = 99}

var bullet_dictionary = {
	1:  {
		chamber_scene = "res://Assets/Images/ChamberBullets/regular_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Player/bullet.tscn"),
		},
	99: {
		chamber_scene = "res://Assets/Images/ChamberBullets/sad_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Player/bullet.tscn"),
	}
}

var chambered_bullet_scenes: Array[PackedScene]

@export var bullet_pattern: Array[BULLET_TYPE]
@export var bullets: Array[Node]

@export var anim_player: Node
@export var cylinder_rotator: Node

@export var score_cost: int = 100



func _ready() -> void:
	anim_player.play_section("RESET")
	for i in range(bullet_pattern.size()):
		var bullet_values = bullet_dictionary[bullet_pattern[i]]
		var chambered_bullet_node = bullets[i]
		var bullet_image_node = chambered_bullet_node.get_child(0)
		bullet_image_node.texture = load(bullet_values.chamber_scene)
		
		var chambered_bullet_scene = bullet_values.combat_scene
		chambered_bullet_scenes.append(chambered_bullet_scene)
		
		if i == 5:
			break
		pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if chambered_bullet_scenes.size() > 0:
			BulletBus.fire_player_bullet.emit(chambered_bullet_scenes[0])
			ScoreBus.score_update.emit(-score_cost)
			bullets[0].queue_free()
			if anim_player.is_playing():
				anim_player.stop()
				var distance_partial_rotated = fmod(cylinder_rotator.rotation_degrees,60.0)
				rotate_chamber(60 - distance_partial_rotated)
			anim_player.play_section("revolve")
			chambered_bullet_scenes.remove_at(0)
			bullets.remove_at(0)
		else:
			print('Oops, looks like yer outta ammo')

func rotate_chamber(rot_deg: float) -> void:
	cylinder_rotator.rotation_degrees += rot_deg
