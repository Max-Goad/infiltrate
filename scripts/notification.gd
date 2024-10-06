class_name Notification extends Node2D

enum Type
{
	NOISE = 0,
	WARNING,
	DANGER,
	QUESTION,
}

#region Variables
@export var target: Node2D
@onready var raycast: MultiCollisionRayCast = $MultiCollisionRayCast
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_action_2"):
		trigger()
#endregion

#region Public Functions
func trigger():
	if raycast.ready_to_fire and target:
		var collisions = raycast.fire_at(target)
		print(collisions)

#endregion

#region Private Functions
#endregion
