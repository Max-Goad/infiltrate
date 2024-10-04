class_name CameraManager extends Node

#region Variables
var cameras: Array[MapBoundedFollowCamera]
#endregion

#region Signals
signal camera_added(camera)
signal camera_changed(camera)
signal camera_removed(camera)
#endregion

#region Engine Functions
func _ready() -> void:
	_collect_cameras()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("player_action_3"):
		change_to_camera(cameras[0])
	elif Input.is_action_just_pressed("player_action_4"):
		change_to_camera(cameras[1])
#endregion

#region Public Functions
func current() -> MapBoundedFollowCamera:
	for camera in cameras:
		if camera.is_current():
			return camera
	assert(false, "couldn't find current camera")
	return cameras[0]

func add_camera(camera: MapBoundedFollowCamera):
	cameras.push_back(camera)
	camera_added.emit(camera)

func remove_camera(camera: MapBoundedFollowCamera):
	assert(camera in cameras)
	cameras.erase(camera)
	camera_removed.emit(camera)

func change_to_camera(camera: MapBoundedFollowCamera):
	assert(camera in cameras)
	if not camera.is_current():
		camera.make_current()
		camera_changed.emit(camera)
#endregion

#region Private Functions
func _collect_cameras():
	for child in get_children():
		if child is MapBoundedFollowCamera:
			cameras.push_back(child)
#endregion
