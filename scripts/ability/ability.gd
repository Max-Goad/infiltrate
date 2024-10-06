class_name Ability extends Node

#region Variables
var cooldown: float
var delay_callable: Callable = func(): pass

## Start Variables
var parent: Player
var direction: Vector2

## Timers
var _cooldown_timer: Timer
var _delay_timer: Timer
var _chain_timer : ChainTimer
#endregion

#region Signals
signal ability_complete
signal cooldown_complete
#endregion

#region Engine Functions
func _init(cooldown = 0.0) -> void:
	self.cooldown = cooldown
	_setup_timers()
#endregion

#region Public Functions
func start(parent: Player, direction: Vector2):
	self.parent = parent
	self.direction = direction
	assert(_cooldown_timer.is_stopped())
	_cooldown_timer.start(cooldown)
	on_start()

func start_after_delay(fn: Callable, delay: float):
	assert(delay > 0.0)
	assert(_delay_timer.is_stopped())
	delay_callable = fn
	_delay_timer.start(delay)

func chain() -> ChainTimer:
	return _chain_timer

func end():
	on_end()

func is_ready() -> bool:
	return _cooldown_timer.is_stopped()
#endregion

#region Abstract Functions
func on_start():
	assert(false, "Ability failed to override base class")

func on_end():
	assert(false, "Ability failed to override base class")
#endregion

#region Private Functions
func _setup_timers():
	_cooldown_timer = Timer.new()
	_cooldown_timer.one_shot = true
	_cooldown_timer.timeout.connect(func(): cooldown_complete.emit())
	add_child(_cooldown_timer)

	_delay_timer = Timer.new()
	_delay_timer.one_shot = true
	_delay_timer.timeout.connect(func(): delay_callable.call())
	add_child(_delay_timer)

	_chain_timer = ChainTimer.new()
	add_child(_chain_timer)
#endregion

enum ID {
	NULL = 0,
	DASH = 1,
}

static func new_from_id(id: Ability.ID) -> Ability:
	match id:
		ID.NULL:
			return NullAbility.new()
		ID.DASH:
			return DashAbility.new()
	assert(false, "unreachable")
	return NullAbility.new()
