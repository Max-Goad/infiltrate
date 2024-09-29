class_name Map extends Node2D

#region Variables
var layers: Array[TileMapLayer] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	for child in get_children():
		if child is TileMapLayer:
			layers.push_back(child)
#endregion

#region Public Functions
#endregion

#region Private Functions
#endregion
