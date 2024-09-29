class_name MapRenderer extends Node2D

const MASK_MATERIAL: Material = preload("res://resources/shaders/all_white.tres")

#region Variables
@export var map: Map
@export var camera: MapBoundedFollowCamera

## Light components are used to generate lights, which
## cut holes through the overlay (via the mask).
@export var light_components: Array[LightComponent] = []

## The overlay is the faded portion of the map which is displayed
## over top of everything else when no there is no vision.
@onready var overlay: CameraAdjustingViewport = $Overlay
## The mask "cuts a hole" through the overlay (using lights)
## in order to reveal the real map below it.
@onready var mask: CameraAdjustingViewport = $Mask

@onready var render: Sprite2D = $Render

@export var show_debug_mask := true
@onready var mask_debug_display: Sprite2D = $"Mask Debug Display"
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
		overlay.register_map_layer(_apply_overlay_adjustments(layer.duplicate()))
		mask.register_map_layer(_apply_mask_shader(layer.duplicate()))
	for component in light_components:
		mask.register_light(component.generate_light())
	render.offset = camera.get_centered_position()
	mask_debug_display.offset = camera.get_centered_position()
	mask_debug_display.visible = show_debug_mask
	self.show()

func _process(_delta: float) -> void:
	overlay.update()
	mask.update()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _apply_overlay_adjustments(layer: TileMapLayer) -> TileMapLayer:
	layer.modulate.v = 0.2
	return layer

func _apply_mask_shader(layer: TileMapLayer) -> TileMapLayer:
	layer.material = MASK_MATERIAL
	return layer
#endregion
