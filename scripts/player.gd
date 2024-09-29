class_name Player extends CharacterBody2D

#region Variables
@onready var movement: CharacterMovementComponent = $CharacterMovementComponent

@export var followers: Array[Node2D] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	for follower in followers:
		follower.global_position = self.global_position
	_process_acceleration()
	_process_deceleration()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _process_acceleration():
	var direction := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	movement.apply_velocity(direction * movement.top_speed)

func _process_deceleration():
	movement.decelerate()
#endregion
