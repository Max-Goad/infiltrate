@tool
class_name Map extends Node2D

#region Variables
var layers: Array[TileMapLayer] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	_collect_layers()
#endregion

#region Public Functions
func get_map_scale() -> Vector2:
	var layer_scale = Vector2.ZERO
	for layer in layers:
		if layer_scale == Vector2.ZERO:
			layer_scale = layer.scale
		else:
			assert(layer_scale == layer.scale)
	return layer_scale

func get_bounds() -> Rect2i:
	var bounds = Rect2i()
	for layer in layers:
		bounds = bounds.merge(layer.get_used_rect())
	return bounds

# Note: All layers must use the same tileset in this scheme
#		Otherwise, attempting to try and get the tile sizes would be impossible
func get_tile_size() -> Vector2i:
	var tileset: TileSet = null
	for layer in layers:
		if tileset == null:
			tileset = layer.tile_set
		else:
			assert(tileset == layer.tile_set)
	return tileset.tile_size

func get_final_size() -> Vector2:
	return Vector2(get_bounds().size) * Vector2(get_tile_size()) * get_map_scale()
#endregion

#region Private Functions
func _collect_layers():
	# TODO: Use groups instead?
	for child in get_children():
		if child is TileMapLayer:
			layers.push_back(child)
#endregion
