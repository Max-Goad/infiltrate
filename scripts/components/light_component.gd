class_name LightComponent extends Node2D

#region Variables
@export_range(0.1, 5.0) var intensity := 1.0 :
	set(value):
		intensity = value
		settings_changed.emit()
#endregion

#region Signals
signal settings_changed
#endregion

#region Engine Functions
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion
