class_name UVMapRenderer extends Node2D

const MASK_MATERIAL: Material = preload("res://resources/shaders/all_white.tres")

#region Variables
@export var map: Map
@export var camera: MapBoundedFollowCamera

## Light components are used to generate lights, which
## cut holes through the overlay (via the mask).
@export var lights: Array[LightComponent] = []

## Additional non-map occluders which are added to the mask layer.
@export var occluders: Array[LightOccluder2D] = []

## Sprites which should appear on the map overlay.
@export var overlay_sprites: Array[Sprite2D] = []

## The overlay is the faded portion of the map which is displayed
## over top of everything else when no there is no vision.
@onready var overlay: SubViewport = $Overlay
## The mask "cuts a hole" through the overlay (using lights)
## in order to reveal the real map below it.
@onready var mask: SubViewport = $Mask

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
	assert(len(lights) > 0)

	overlay.add_child(UVMapCamera.new(camera))
	mask.add_child(UVMapCamera.new(camera))
	for ref_layer in map.layers:
		overlay.add_child(as_overlay(UVMapLayer.new(ref_layer)))
		mask.add_child(as_mask(UVMapLayer.new(ref_layer)))
	for ref_comp in lights:
		# Only add the lights to the mask; the actual lights will exist in the real map
		mask.add_child(UVMapLight.generate(ref_comp))

	# TODO: How do we handle replication of data between the originals and these copies?
	# TODO: Fix global position replication
	for sprite in overlay_sprites:
		overlay.add_child(as_overlay(sprite.duplicate()))
	for occluder in occluders:
		mask.add_child(as_mask(occluder.duplicate()))

	render.offset = camera.screen_center()
	mask_debug_display.offset = camera.screen_center()
	mask_debug_display.visible = show_debug_mask
	self.show()
#endregion

#region Public Functions
#endregion

#region Private Functions
func as_overlay(node):
	node.modulate.v = 0.2
	return node

func as_mask(node):
	node.material = MASK_MATERIAL
	return node
#endregion
