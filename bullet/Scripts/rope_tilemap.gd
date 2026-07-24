extends TileMapLayer

@export var cut_sample_spacing: float = 8.0

const CRATE_TILE_COORDS := Vector2i(2, 0)
const BOULDER_TILE_COORDS := Vector2i(3, 0)
const CRATE_SCENE := preload("res://Scenes/Objects/Breakables/crate.tscn")
const BOULDER_SCENE := preload("res://Scenes/Objects/Boulder.tscn")

func _ready() -> void:
	add_to_group("rope")

func cut_by_bullet(hit_position: Vector2) -> bool:
	var cell: Vector2i = local_to_map(to_local(hit_position))
	if get_cell_source_id(cell) == -1:
		return false

	_break_all_rope()
	return true

func cut_along_segment(segment_start: Vector2, segment_end: Vector2) -> bool:
	var segment: Vector2 = segment_end - segment_start
	var distance: float = segment.length()
	if distance == 0.0:
		return cut_by_bullet(segment_end)

	var direction: Vector2 = segment / distance
	var steps := int(ceil(distance / max(cut_sample_spacing, 1.0)))

	for step in range(steps + 1):
		var sample_distance: float = minf(step * cut_sample_spacing, distance)
		var sample_position: Vector2 = segment_start + direction * sample_distance
		if cut_by_bullet(sample_position):
			return true

	return false

func _break_all_rope() -> void:
	var used_cells: Array[Vector2i] = get_used_cells()
	var parent_node: Node = get_parent()

	for cell: Vector2i in used_cells:
		_spawn_hanging_object_for_cell(parent_node, cell)
		erase_cell(cell)

func _spawn_hanging_object_for_cell(parent_node: Node, cell: Vector2i) -> void:
	if parent_node == null:
		return

	var atlas_coords: Vector2i = get_cell_atlas_coords(cell)
	var spawned_node: Node2D = null

	if atlas_coords == CRATE_TILE_COORDS:
		spawned_node = CRATE_SCENE.instantiate() as Node2D
	elif atlas_coords == BOULDER_TILE_COORDS:
		spawned_node = BOULDER_SCENE.instantiate() as Node2D

	if spawned_node == null:
		return

	parent_node.add_child(spawned_node)
	spawned_node.global_position = to_global(map_to_local(cell))
