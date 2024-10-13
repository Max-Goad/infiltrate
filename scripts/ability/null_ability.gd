class_name NullAbility extends Ability

#region Variables
#endregion

#region Signals
#endregion

#region Engine Functions
func _init() -> void:
	super._init(MovementComponent.new())
#endregion

#region Public Functions
func on_start():
	# Do nothing
	pass

func on_stop():
	# Do nothing
	pass
#endregion

#region Private Functions
#endregion
