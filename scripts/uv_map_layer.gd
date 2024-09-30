class_name UVMapLayer extends TileMapLayer

const MASK_MATERIAL: Material = preload("res://resources/shaders/all_white.tres")

static func generate_overlay(reference: TileMapLayer) -> UVMapLayer:
	var uv_map_layer: TileMapLayer = reference.duplicate()
	uv_map_layer.modulate.v = 0.2
	return uv_map_layer

static func generate_mask(reference: TileMapLayer) -> UVMapLayer:
	var uv_map_layer: TileMapLayer = reference.duplicate()
	uv_map_layer.material = MASK_MATERIAL
	return uv_map_layer
