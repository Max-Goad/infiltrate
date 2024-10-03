class_name ScreenBoundSprite extends Sprite2D

#region Variables
@export var camera: MapBoundedFollowCamera
@export var reference: Sprite2D

@export_group("Limits")
@export var close_distance := 300
@export var far_distance := 1000
@export var disappear_past_far := true
@export_range(0.1, 1.0, 0.05) var max_size := 1.0
@export_range(0.1, 1.0, 0.05) var min_size := 0.25
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
	const buffer = 25
	var bounds := camera.get_viewport_rect().grow(-buffer)
	bounds.position = camera.global_top_left() + Vector2(buffer, buffer)

	var intersection = Math.segment_intersects_rect(camera.global_center(), reference.global_position, bounds)
	if not intersection:
		self.hide()
		return

	var distance = camera.global_center().distance_to(reference.global_position)
	if disappear_past_far and distance > far_distance:
		self.hide()
		return

	global_position = intersection
	global_scale = _get_scale_from_distance(distance)
	self.show()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _get_scale_from_distance(distance: float) -> Vector2:
	var percent = clamp((distance - close_distance) / (far_distance - close_distance), 0.0, 1.0)
	var new_scale = (max_size - min_size) * (1.0-percent) + min_size
	return Vector2(new_scale, new_scale)
#endregion
