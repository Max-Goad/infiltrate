class_name CameraAdjustingViewport extends SubViewport

#region Variables

@onready var map_objects: Node2D = $"Map Objects"
var camera: MapBoundedFollowCamera
var player_light: VisibilityLight
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	#assert(camera)
	pass

func _process(_delta: float) -> void:
	if camera:
		var target_position = -camera.get_screen_center_position() + (camera.get_viewport_rect().size / 2)
		map_objects.global_position = target_position
		if player_light:
			player_light.global_position = target_position + player_light.component.global_position
#endregion

#region Public Functions
func register_camera(camera: MapBoundedFollowCamera):
	self.camera = camera

func register_map_object(node: Node2D):
	map_objects.add_child(node)

func register_player_light(light: VisibilityLight):
	self.player_light = light
	add_child(light)
#endregion

#region Private Functions
#endregion
