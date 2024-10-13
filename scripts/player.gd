class_name Player extends CharacterBody2D

#region Variables
@onready var movement: CharacterMovementComponent = $CharacterMovementComponent
@onready var sprite: AnimatedSprite2D = $Sprite

var last_movement_direction := Vector2.RIGHT

var abilities: Array[Ability] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	#_setup_test_abilities()
	pass

func _process(_delta: float) -> void:
	_process_acceleration()
	#_process_input()
	_process_animation()
	_process_deceleration()
#endregion

#region Public Functions
#endregion

#region Private Functions
func _process_acceleration():
	var direction := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	movement.apply_velocity(direction * movement.top_speed)
	if direction != Vector2.ZERO:
		last_movement_direction = direction

func _process_deceleration():
	movement.decelerate()

func _process_animation():
	if movement.moving():
		sprite.play("run")
	else:
		sprite.play("idle")
	if last_movement_direction.x > 0:
		sprite.flip_h = false
	elif last_movement_direction.x < 0:
		sprite.flip_h = true
#endregion
