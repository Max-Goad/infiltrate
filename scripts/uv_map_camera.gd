class_name UVMapCamera extends Camera2D

var reference: Camera2D

func _init(reference: Camera2D):
	self.reference = reference

func _process(_delta: float) -> void:
	# We don't use the reference's position because for some dumb reason
	# the "position" of the camera continues to increment/decrement even
	# when it is stopped by the specified bound limits.
	self.global_position = reference.get_screen_center_position()
