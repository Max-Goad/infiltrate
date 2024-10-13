extends Node

const NO_CURRENT_LOADOUT = -1
var NULL_LOADOUT = AbilityLoadout.new()

#region Variables
## { id : AbilityLoadout }
var loadouts: Dictionary = { NO_CURRENT_LOADOUT: NULL_LOADOUT }

var current_loadout_id: int = NO_CURRENT_LOADOUT :
	set(value):
		current_loadout_id = value
		print("set to %s" % value)
#endregion

#region Signals
signal loadout_changed(loadout)
signal ability_pressed(slot_num)
signal ability_released(slot_num)
#endregion

#region Engine Functions
func _ready() -> void:
	print(current_loadout_id)

func _unhandled_input(event: InputEvent) -> void:
	var i = 0
	for action in ["player_action_1", "player_action_2", "player_action_3", "player_action_4"]:
		if event.is_action_pressed(action):
			initiate_press(i)
			#print("press %s" % event)
		elif event.is_action_released(action):
			initiate_release(i)
			#print("release %s" % event)
		i += 1
#endregion

#region Public Functions
func register(loadout: AbilityLoadout) -> void:
	print("AbilityRegister: register %s" % loadout)
	var id = loadout.get_instance_id()
	assert(id not in loadouts)
	loadouts[id] = loadout
	if current_loadout_id == NO_CURRENT_LOADOUT:
		make_current(loadout)

func unregister(loadout: AbilityLoadout) -> AbilityLoadout:
	print("AbilityRegister: unregister %s" % loadout)
	var id = loadout.get_instance_id()
	assert(id in loadouts)
	var erased_loadout = loadouts[id]
	loadouts.erase(id)
	if current_loadout_id == id:
		reset_current()
	return erased_loadout

func current_loadout() -> AbilityLoadout:
	return loadouts[current_loadout_id]

func make_current(loadout: AbilityLoadout):
	print("AbilityRegister: make_current %s" % loadout)
	var id = loadout.get_instance_id()
	assert(id in loadouts)
	current_loadout_id = id
	loadout_changed.emit(current_loadout())

func reset_current():
	print("AbilityRegister: reset_current")
	current_loadout_id = NO_CURRENT_LOADOUT
	loadout_changed.emit(current_loadout())

## Return value: Whether the ability press was processed as successful or not
func initiate_press(slot_num: int) -> bool:
	var loadout = current_loadout()
	if not loadout.has_ability(slot_num):
		print("AbilityRegister: initiate_press %s does not exist!" % slot_num)
		return false
	var ability: Ability = loadout.get_ability(slot_num)
	if not ability.is_ready():
		print("AbilityRegister: initiate_press %s (%s) not ready" % [slot_num, ability])
		return false

	ability.press()
	ability_pressed.emit(slot_num)
	print("AbilityRegister: initiate_press %s (%s) success" % [slot_num, ability])
	return true

## Return value: Whether the ability release was processed as successful or not
func initiate_release(slot_num) -> bool:
	var loadout = current_loadout()
	if not loadout.has_ability(slot_num):
		print("AbilityRegister: initiate_release %s does not exist!" % slot_num)
		return false
	var ability: Ability = loadout.get_ability(slot_num)
	if not ability.is_pressed():
		print("AbilityRegister: initiate_release %s (%s) not pressed" % [slot_num, ability])
		return false

	ability.release()
	ability_released.emit(slot_num)
	print("AbilityRegister: initiate_release %s (%s) success" % [slot_num, ability])
	return true
#endregion

#region Private Functions
#endregion
