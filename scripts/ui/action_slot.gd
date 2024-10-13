class_name ActionSlot extends PanelContainer

@export_range(1, AbilityLoadout.NUM_SLOTS, 1) var slot: int
@onready var texture: TextureRect = $Texture
@onready var cooldown: ProgressBar = $Cooldown
@onready var timer: Timer = $Timer

func _ready() -> void:
	AbilityRegister.loadout_changed.connect(_loadout_changed)
	AbilityRegister.ability_cooldown_initiated.connect(_cooldown_initiated)
	AbilityRegister.ability_cooldown_finished.connect(_cooldown_finished)

func _process(_delta: float) -> void:
	if not timer.is_stopped():
		cooldown.value = timer.time_left * 100.0 / timer.wait_time

func _reset():
	timer.stop()
	cooldown.value = 0

func _loadout_changed(loadout: AbilityLoadout):
	if not loadout.has_ability(slot):
		# reset texture to null ability texture
		return
	# set texture to ability texture
	_reset()

func _cooldown_initiated(slot_num: int, time: float):
	if slot_num+1 != self.slot:
		return
	timer.start(time)

func _cooldown_finished(slot_num: int):
	if slot_num+1 != self.slot:
		return
	_reset()
