class_name ActionDisplayButton extends TextureButton

@export var action: StringName = ""

func _ready() -> void:
	assert(not action.is_empty())
	assert(toggle_mode)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(action):
		self.button_pressed = true
	elif Input.is_action_just_released(action):
		self.button_pressed = false
