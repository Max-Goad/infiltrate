class_name UVMapLayer extends TileMapLayer

var reference: TileMapLayer

func _init(reference: TileMapLayer) -> void:
	self.reference = reference
	on_reference_updated()

func on_reference_updated():
	self.global_transform = reference.global_transform
	self.tile_set = reference.tile_set
	self.tile_map_data = reference.tile_map_data
	self.collision_enabled = false
