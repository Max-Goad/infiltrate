class_name UVMapLight extends PointLight2D

const UV_MAP_LIGHT_TEMPLATE = preload("res://scenes/uv_map_light.tscn")

var reference: LightComponent

static func generate(reference: LightComponent) -> UVMapLight:
	var uv_map_light: UVMapLight = UV_MAP_LIGHT_TEMPLATE.instantiate()
	uv_map_light.reference = reference
	reference.settings_changed.connect(uv_map_light.on_settings_changed)
	uv_map_light.on_settings_changed()
	return uv_map_light

func _process(_delta: float) -> void:
	self.global_position = reference.global_position

func on_settings_changed():
	texture_scale = reference.intensity
