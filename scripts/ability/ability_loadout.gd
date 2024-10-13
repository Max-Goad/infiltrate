class_name AbilityLoadout extends Node

const NUM_SLOTS = 4

#region Variables
@export var movement: MovementComponent
@export var slot_1_id = Ability.ID.NULL
@export var slot_2_id = Ability.ID.NULL
@export var slot_3_id = Ability.ID.NULL
@export var slot_4_id = Ability.ID.NULL

var _abilities: Array[Ability] = []
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(movement)
	_initialize_abilities()

func _enter_tree() -> void:
	AbilityRegister.register(self)

func _exit_tree() -> void:
	AbilityRegister.unregister(self)
#endregion

#region Public Functions
func has_ability(slot_num: int) -> bool:
	return slot_num >= 0 and slot_num < NUM_SLOTS

func get_ability(slot_num: int) -> Ability:
	assert(has_ability(slot_num))
	return _abilities[slot_num]

func make_current():
	AbilityRegister.make_current(self)
#endregion

#region Private Functions
func _initialize_abilities():
	var i = 0
	_abilities.resize(NUM_SLOTS)
	for id in [slot_1_id, slot_2_id, slot_3_id, slot_4_id]:
		_abilities[i] = Ability.new_from_id(id, movement)
		add_child(_abilities[i])
		i += 1
#endregion
