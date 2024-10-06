class_name DashAbility extends Ability

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init()
#endregion

#region Public Functions
func on_start():
	self.parent.movement.lock_until_stopped()
	self.parent.movement.accelerate(6.0, MovementComponent.IGNORE_LOCK)

func on_end():
	pass
#endregion

#region Private Functions
#endregion
