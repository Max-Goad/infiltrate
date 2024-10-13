class_name DashAbility extends Ability

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init(movement: MovementComponent) -> void:
	super._init(movement, 3.0)
#endregion

#region Public Functions
func on_press():
	self.movement.lock_until_stopped()
	self.movement.accelerate(6.0, MovementComponent.IGNORE_LOCK)
	self.initiate_cooldown()

func on_release():
	pass
#endregion

#region Private Functions
#endregion
