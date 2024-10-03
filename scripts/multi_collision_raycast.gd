class_name MultiCollisionRayCast extends RayCast2D

#region Variables
var ready_to_fire := true
var current_collision: Node2D
var original_position: Vector2
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	original_position = global_position
	hit_from_inside = true
	collide_with_areas = true
	collide_with_bodies = true
#endregion

#region Public Functions
func fire_at(target: Node2D) -> Dictionary:
	_face_towards(target)
	var collisions: Array[Node2D] = []
	var current_iteration = 0
	const delta = 5
	const tolerance = 5
	var target_iterations = (original_position.distance_to(target.global_position) / delta) + tolerance
	while current_collision != target and current_iteration < target_iterations:
		global_position = global_position.move_toward(target.global_position, delta)
		force_raycast_update()
		if is_colliding():
			var collider = get_collider()
			if collider == target:
				current_collision = collider
			elif collider is TileMapLayer:
				if current_collision == null:
					print("enter wall @ %s" % global_position)
					collisions.push_back(collider)
					current_collision = collider
		else:
			if current_collision != null:
				print("exit wall @ %s" % global_position)
				current_collision = null
		current_iteration += 1
	_reset()
	return {
		"count" : len(collisions),
		"collisions" : collisions,
		"iterations" : current_iteration,
	}

func collision_info() -> Dictionary:
	if is_colliding():
		return {
			"colliding" : false, }
	else:
		return {
			"colliding" : true,
			"collider" : get_collider(),
			"collider_rid" : get_collider_rid(),
			"collision_point" : get_collision_point(),
		}
#endregion

#region Private Functions
func _face_towards(target: Node2D):
	target_position = (target.global_position - original_position).normalized()

func _reset():
	global_position = original_position
	current_collision = null
	ready_to_fire = true
#endregion
