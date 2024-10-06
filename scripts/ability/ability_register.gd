class_name AbilityRegister extends Node

const NO_CURRENT_LOADOUT = -1
var NULL_LOADOUT = AbilityLoadout.new()

#region Variables
## { id : AbilityLoadout }
var loadouts: Dictionary = { NO_CURRENT_LOADOUT: NULL_LOADOUT }

var current_loadout_id: int = NO_CURRENT_LOADOUT
#endregion

#region Signals
signal loadout_changed(AbilityLoadout)
signal ability_started(slot_num)
#endregion

#region Engine Functions
#endregion

#region Public Functions
func register(id: int, loadout: AbilityLoadout) -> void:
	assert(id not in loadouts)
	loadouts[id] = loadout
	if current_loadout_id == NO_CURRENT_LOADOUT:
		make_current(id)

func unregister(id: int) -> AbilityLoadout:
	assert(id in loadouts)
	var erased_loadout = loadouts[id]
	loadouts.erase(id)
	if current_loadout_id == id:
		make_current(NO_CURRENT_LOADOUT)
	return erased_loadout

func current_loadout() -> AbilityLoadout:
	return loadouts[current_loadout_id]

func make_current(id: int):
	assert(id in loadouts)
	current_loadout_id = id
	loadout_changed.emit(current_loadout())

## Return value: Whether the ability started or not
func start_ability(slot_num: int, parent: Player, direction: Vector2) -> bool:
	var loadout = current_loadout()
	if not loadout.has_ability(slot_num):
		print("AbilityRegister: start_ability %s does not exist!" % slot_num)
		return false
	var ability: Ability = loadout.get_ability(slot_num)
	if not ability.is_ready():
		print("AbilityRegister: start_ability %s (%s) not ready" % [slot_num, ability])
		return false

	ability.start(parent, direction)
	ability_started.emit(slot_num)
	print("AbilityRegister: start_ability %s (%s) success" % [slot_num, ability])
	return true
#endregion

#region Private Functions
#endregion
