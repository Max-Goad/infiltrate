class_name TestCollisionTracer extends Node2D

#region Variables
@export var target: Node2D

@onready var raycast: RayCast2D = $RayCast2D

var ready_to_fire := true
var found_target := false

var counter = 0
var is_colliding_with_wall := false
#endregion

#region Signals
#endregion

#region Engine Functions
func _ready() -> void:
	assert(target)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_action_1"):
		if ready_to_fire:
			_fire()
	if Input.is_action_just_pressed("player_action_2"):
		print(raycast.is_colliding())
		if raycast.is_colliding():
			print(raycast.get_collider())
			print(raycast.get_collider_rid())
			print(raycast.get_collider_shape())
			print(raycast.get_collision_point())
	# ready_to_fire = true
	#var params = PhysicsRayQueryParameters2D.create(global_position, target.global_position)
	#var result = get_world_2d().direct_space_state.intersect_ray(params)
	#print(result)


#endregion

#region Public Functions
#endregion

#region Private Functions
func _fire():
	raycast.target_position = (target.global_position - global_position).normalized()
	while true:
		raycast.global_position = raycast.global_position.move_toward(target.global_position, 1)
		raycast.force_raycast_update()
		#print("raycast @ %s is colliding? %s" % [raycast.global_position, raycast.is_colliding()])
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is TileMapLayer:
				if not is_colliding_with_wall:
					print("enter wall @ %s" % raycast.global_position)
					is_colliding_with_wall = true
					counter += 1
			elif collider == target:
				print("found target (through %s walls)" % counter)
				_reset()
				return
		else:
			if is_colliding_with_wall:
				print("exit wall @ %s" % raycast.global_position)
				is_colliding_with_wall = false

func _reset():
	found_target = true
	raycast.global_position = global_position
	ready_to_fire = true
	counter = 0
#endregion
