class_name ScreenBoundSprite extends Node2D

#region Variables
@export var camera: MapBoundedFollowCamera
@onready var sprite: Sprite2D = $Sprite2D

@export var hide_on_screen := false
@export var close_distance := 100
@export var far_distance := 1000
@export_range(0.1, 1.0, 0.1) var max_size := 1.0
@export_range(0.1, 1.0, 0.1) var min_size := 0.1
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(camera)
	assert(min_size <= max_size)

func _process(_delta: float) -> void:
	var bounds := camera.get_viewport_rect().grow_individual(-20, -14, -20, -14)
	bounds.position = camera.bounded_position()
	var on_screen = bounds.has_point(global_position)
	if on_screen:
		sprite.global_position = global_position
		sprite.scale = Vector2(max_size, max_size)
		visible = not hide_on_screen
	else:
		sprite.global_position = global_position.clamp(bounds.position, bounds.end)
		print("pos: %s - %s - %s" % [global_position, sprite.global_position, bounds])
		sprite.scale = _get_scale_by_distance()
		visible = true
#endregion

#region Public Functions
#endregion

#region Private Functions
func _get_scale_by_distance() -> Vector2:
	var distance = camera.get_screen_center_position().distance_to(global_position)
	var percent = (distance - close_distance) / (far_distance - close_distance)
	var new_scale = (max_size - min_size) * (1.0-percent) + min_size
	print({"distance" : distance, "percent" : percent, "new_scale" : new_scale})
	return Vector2(new_scale, new_scale)
#endregion
