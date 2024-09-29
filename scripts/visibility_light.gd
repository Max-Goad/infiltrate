class_name VisibilityLight extends PointLight2D

#region Variables
@export var parent: LightComponent
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(parent)

func _process(_delta: float) -> void:
	self.global_position = parent.global_position
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion
