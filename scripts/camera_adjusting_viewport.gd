class_name CameraAdjustingViewport extends SubViewport

#region Variables
var camera: MapBoundedFollowCamera
var camera_size: Vector2
var map_layers: Array[TileMapLayer]
var lights: Array[VisibilityLight]
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	self.size = get_window().size
#endregion

#region Public Functions
func register_camera(camera: MapBoundedFollowCamera):
	self.camera = camera

func register_map_layer(layer: TileMapLayer):
	map_layers.push_back(layer)
	add_child(layer)

func register_light(light: VisibilityLight):
	lights.push_back(light)
	add_child(light)

func update():
	assert(camera)
	var target_position = -camera.get_screen_center_position() + camera.get_centered_position()
	for layer in map_layers:
		layer.global_position = target_position
	for light in lights:
		light.update_position(target_position)
#endregion

#region Private Functions
#endregion
