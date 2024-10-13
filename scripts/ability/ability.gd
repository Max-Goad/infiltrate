class_name Ability extends Node

enum State { READY = 0, PRESSED, COOLDOWN }

#region Variables
var movement: MovementComponent
var cooldown: float
var state: State = State.READY

## Timers
var _cooldown_timer: Timer
var _chain_timer : ChainTimer
#endregion

#region Signals
signal ability_complete
signal cooldown_complete
#endregion

#region Engine Functions
func _init(movement: MovementComponent, cooldown = 0.0) -> void:
	self.movement = movement
	self.cooldown = cooldown
	_setup_timers()
#endregion

#region Public Functions
func press():
	on_press()
	state = State.PRESSED

func release():
	on_release()
	if _cooldown_timer.is_stopped():
		initiate_cooldown()

func chain() -> ChainTimer:
	return _chain_timer

func initiate_cooldown():
	assert(_cooldown_timer.is_stopped())
	_cooldown_timer.start(cooldown)
	state = State.COOLDOWN

func is_ready() -> bool:
	return state == State.READY and _cooldown_timer.is_stopped()

func is_pressed() -> bool:
	return state == State.PRESSED and _cooldown_timer.is_stopped()

func is_in_cooldown() -> bool:
	return state == State.COOLDOWN and not _cooldown_timer.is_stopped()
#endregion

#region Abstract Functions
func on_press():
	assert(false, "Ability failed to override base class")

func on_release():
	assert(false, "Ability failed to override base class")
#endregion

#region Private Functions
func _setup_timers():
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(_cooldown_timer)

	_chain_timer = ChainTimer.new()
	add_child(_chain_timer)

func _on_cooldown_timeout():
	state = State.READY
	cooldown_complete.emit()
#endregion

enum ID {
	NULL = 0,
	DASH = 1,
}

static func new_from_id(id: Ability.ID, movement: MovementComponent) -> Ability:
	match id:
		ID.NULL:
			return NullAbility.new()
		ID.DASH:
			return DashAbility.new(movement)
	assert(false, "unreachable")
	return NullAbility.new()
