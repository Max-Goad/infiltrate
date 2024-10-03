class_name ScreenBoundSprite extends Sprite2D

#region Variables
@export var camera: MapBoundedFollowCamera
@export var reference: Sprite2D

@export var close_distance := 300
@export var far_distance := 1000
@export_range(0.1, 1.0, 0.1) var max_size := 1.0
@export_range(0.1, 1.0, 0.1) var min_size := 0.1
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(camera and reference)
	assert(min_size <= max_size)
	self.self_modulate = reference.modulate
	add_child(reference.duplicate())

func _process(_delta: float) -> void:
	const buffer = 20
	var bounds := camera.get_viewport_rect().grow(-buffer)
	bounds.position = camera.bounded_position() + Vector2(buffer, buffer)
	var intersection = Math.segment_intersects_rect(camera.get_screen_center_position(), reference.global_position, bounds)
	if intersection:
		global_position = intersection
		global_scale = _get_scale_by_distance(reference.global_position)
		self.show()
	else:
		self.hide()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _get_scale_by_distance(target: Vector2) -> Vector2:
	var distance = camera.get_screen_center_position().distance_to(target)
	var percent = clamp((distance - close_distance) / (far_distance - close_distance), 0.0, 1.0)
	var new_scale = (max_size - min_size) * (1.0-percent) + min_size
	return Vector2(new_scale, new_scale)
#endregion
