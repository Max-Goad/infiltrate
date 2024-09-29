class_name LightComponent extends Node2D

const VISIBILITY_LIGHT = preload("res://scenes/visibility_light.tscn")

enum Relativity {
	## World-relative lights, such as static lights,
	## are unaffected by the camera's current position.
	WORLD_RELATIVE = 0,
	## Camera-relative lights, such as the player light,
	## set their positions based on the camera space.
	CAMERA_RELATIVE,
}

#region Variables
@export var relativity: Relativity
@export_range(0.1, 5.0) var intensity := 1.0
var light: VisibilityLight
#endregion

#region Signals
#endregion

#region Engine Functions
#endregion

#region Public Functions
func generate_light() -> VisibilityLight:
	light = VISIBILITY_LIGHT.instantiate()
	light.component = self
	return light
#endregion

#region Private Functions
#endregion
