class_name MapRenderer extends Node2D

const MASK_MATERIAL: Material = preload("res://resources/shaders/all_white.tres")
const VISIBILITY_LIGHT = preload("res://scenes/visibility_light.tscn")

#region Variables
@export var map: Map
@export var camera: Camera2D

## These components are used to generate lights, which will
## "cut a hole" through the overlay (via the mask).
@export var light_components: Array[LightComponent] = []

## The overlay is the faded portion of the map which is displayed
## over top of everything else when no there is no vision.
@onready var overlay: CameraAdjustingViewport = $Overlay
## The mask "cuts a hole" through the overlay (using lights)
## in order to reveal the real map below it.
@onready var mask: CameraAdjustingViewport = $Mask

@onready var render: Sprite2D = $Render
@onready var mask_debug: Sprite2D = $"Mask Debug"
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(map)
	assert(camera)
	overlay.register_camera(camera)
	mask.register_camera(camera)
	for layer in map.layers:
		overlay.register_map_object(to_overlay(layer.duplicate()))
		mask.register_map_object(apply_mask_shader(layer.duplicate()))
	for component in light_components:
		mask.register_player_light(generate_light(component))
	self.show()
#endregion

#region Public Functions
#endregion

#region Private Functions
func to_overlay(layer: TileMapLayer) -> TileMapLayer:
	layer.modulate.v = 0.2
	return layer

func apply_mask_shader(layer: TileMapLayer) -> TileMapLayer:
	layer.material = MASK_MATERIAL
	return layer

func generate_light(component: LightComponent) -> VisibilityLight:
	var new_light: VisibilityLight = VISIBILITY_LIGHT.instantiate()
	new_light.component = component
	new_light.texture_scale = component.intensity
	return new_light

#endregion
