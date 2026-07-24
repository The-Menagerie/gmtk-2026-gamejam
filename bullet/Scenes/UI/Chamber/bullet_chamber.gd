extends Control

enum BULLET_TYPE {REGULAR = 5, RUBBER = 4, PIERCING = 3, FLY = 2, SWAP = 1, SAD = 99}

var bullet_dictionary = {
	5:  {
		chamber_scene = "res://Assets/Images/ChamberBullets/regular_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/bullet.tscn"),
		},
	4: {
		chamber_scene = "res://Assets/Images/ChamberBullets/rubber_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/rubber_bullet.tscn"),
	},
	3: {
		chamber_scene = "res://Assets/Images/ChamberBullets/piercing_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/piercing_bullet.tscn"),
	},
	2: {
		chamber_scene = "res://Assets/Images/ChamberBullets/fly_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/fly_bullet.tscn"),
	},
	1: {
		chamber_scene = "res://Assets/Images/ChamberBullets/swap_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/swap_bullet.tscn"),
	},
	99: {
		chamber_scene = "res://Assets/Images/ChamberBullets/sad_bullet.png",
		combat_scene = preload("res://Scenes/Objects/Bullets/bullet.tscn"),
	}
}

var chambered_bullet_scenes: Array[PackedScene]

@export var bullet_pattern: Array[BULLET_TYPE]
@export var bullets: Array[Node]

@export var anim_player: Node
@export var cylinder_rotator: Node

@export var score_cost: int = 100

var cylinder_start_pos
var scale_modifier

@onready var cylinder_container = $alignment/VBoxContainer
@onready var alignment = $alignment

func _ready() -> void:
	#var screen_dimensions = get_viewport().get_visible_rect()
	#var screen_x = screen_dimensions.size.x
	#var screen_y = screen_dimensions.size.y
	fit_resolution()
	
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

func shift_chamber_pos(pos_pix_x: float, pos_pix_y: float) -> void:
	cylinder_rotator.position.x += pos_pix_x
	cylinder_rotator.position.y += pos_pix_y

func reset_chamber_pos() -> void:
	cylinder_rotator.position = cylinder_start_pos

func fit_resolution() -> void:
	var screen_x = self.size.x
	var screen_y = self.size.y
	if (1920.0 - screen_x) > (1080.0 - screen_y):
		#var new_size = round(screen_x * (128.0/1920.0))
		scale_modifier = screen_x/1920.0
		alignment.scale.x *= scale_modifier
		alignment.scale.y *= scale_modifier
	elif (1080.0 - screen_y) >= (1920.0 - screen_x):
		scale_modifier = screen_y/1080.0
		alignment.scale.x *= scale_modifier
		alignment.scale.y *= scale_modifier
	
	alignment.position.y += (1 - scale_modifier)*256
	cylinder_start_pos = cylinder_rotator.position
