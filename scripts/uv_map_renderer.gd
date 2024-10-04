@tool
class_name UVMapRenderer extends Node2D

const MASK_MATERIAL: Material = preload("res://resources/shaders/all_white.tres")

#region Variables
@export var map: Map
@export var camera_manager: CameraManager

## Mappings of original cameras to their UVMap counterparts.
## Stored as a dict of { CameraID : UVMapCamera }.
## This allows us to be able to quickly identify and switch
## all cameras to the proper ones when a switch occurs.
var overlay_cameras: Dictionary
var mask_cameras: Dictionary

## The sprite used to display the final mask to the screen
@onready var render: Sprite2D = $Render

@export_group("Lights")
## Light components are used to generate lights, which
## cut holes through the overlay (via the mask).
@export var lights: Array[LightComponent] = []

## Additional non-map occluders which are added to the mask layer.
@export var occluders: Array[LightOccluder2D] = []

@export_group("Overlay")
## Sprites which should appear on the map overlay.
@export var overlay_sprites: Array[Sprite2D] = []

## How bright the overlay should appear compared to the original
## 0.0 = completely black, 1.0 = same as original
@export_range(0.1, 1.0, 0.05) var overlay_brightness := 0.5

## The overlay is the faded portion of the map which is displayed
## over top of everything else when no there is no vision.
@onready var overlay: SubViewport = $Overlay

## The toggleable simulated "dim" overlay used to test out the
## approximate darkness of the overlay while still in editor.
@onready var editor_overlay: ColorRect = $"Editor Overlay"
@export var show_editor_overlay := false:
	set(value):
		show_editor_overlay = value
		_update_editor_overlay()

@export_group("Mask")
## The mask "cuts a hole" through the overlay (using lights)
## in order to reveal the real map below it.
@onready var mask: SubViewport = $Mask

## The toggleable visual of the mask SubViewport,
## shown in the top corner for debug purposes.
@onready var mask_debug_display: Sprite2D = $"Mask Debug Display"
@export var show_debug_display := false
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	_update_editor_overlay()
	if Engine.is_editor_hint():
		return

	assert(map and camera_manager)

	camera_manager.camera_added.connect(_add_camera)
	camera_manager.camera_removed.connect(_remove_camera)
	camera_manager.camera_changed.connect(_change_camera)
	for camera in camera_manager.cameras:
		_add_camera(camera)

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

	_update_render_positions()
	mask_debug_display.visible = show_debug_display
	self.show()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	self.global_position = camera_manager.current().global_top_left()

	_update_render_positions()
#endregion

#region Public Functions
func as_overlay(node):
	node.modulate.v = overlay_brightness
	return node

func as_mask(node):
	node.material = MASK_MATERIAL
	return node
#endregion

#region Private Functions
func _update_render_positions():
	var current_camera = camera_manager.current()
	overlay.size = Vector2(get_window().size) / current_camera.zoom
	mask.size = Vector2(get_window().size) / current_camera.zoom
	render.offset = current_camera.window_center()
	mask_debug_display.offset = current_camera.window_center()
	current_camera.force_update_scroll()

func _update_editor_overlay():
	if not Engine.is_editor_hint() or not map or not show_editor_overlay:
		if editor_overlay:
			editor_overlay.hide()
		return
	editor_overlay.global_position = map.global_position
	print(map.get_bounds())
	editor_overlay.set_size(map.get_final_size())
	editor_overlay.color = Color(Color.BLACK, 1.0-overlay_brightness)
	editor_overlay.show()

func _add_camera(camera: MapBoundedFollowCamera):
	var overlay_camera = UVMapCamera.new(camera)
	overlay_cameras[camera.get_instance_id()] = overlay_camera
	overlay.add_child(overlay_camera)
	var mask_camera = UVMapCamera.new(camera)
	mask_cameras[camera.get_instance_id()] = mask_camera
	mask.add_child(mask_camera)

func _remove_camera(camera: MapBoundedFollowCamera):
	var id = camera.get_instance_id()
	assert(id in overlay_cameras)
	assert(id in mask_cameras)
	overlay_cameras[id].queue_free()
	mask_cameras[id].queue_free()
	overlay_cameras.erase(id)
	mask_cameras.erase(id)

func _change_camera(camera: MapBoundedFollowCamera):
	var id = camera.get_instance_id()
	assert(id in overlay_cameras)
	assert(id in mask_cameras)
	overlay_cameras[id].make_current()
	mask_cameras[id].make_current()
	_update_render_positions()
#endregion
