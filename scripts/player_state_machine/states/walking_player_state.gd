extends State

@export var idle_state: State
@export var running_state: State
@export var ground_jumping_state: State
@export var falling_state: State

@export var mesh_root: Node3D
@export var walking_speed: float = 4.0
@export var walking_acceleration: float = 6.0

var movement_direction: Vector3

func process_input(event: InputEvent) -> State:
	var is_walking = Input.is_action_pressed("movement")
	var is_running = Input.is_action_pressed("sprint")
	var is_jumping = Input.is_action_pressed("jump")
	
	if is_walking and is_running:
		return process_state_change(running_state)
	if is_jumping and parent.is_on_floor():
		return process_state_change(ground_jumping_state)
	if not is_walking:
		return process_state_change(idle_state)
		
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	return null
	
func process_physics(delta: float) -> State:
	var is_falling = !parent.is_on_floor()
	# set player direction
	parent.direction = movement_direction.rotated(Vector3.UP, parent.cam_rotation)
	# set player velocity
	parent.velocity.x = walking_speed * parent.direction.normalized().x
	parent.velocity.z = walking_speed * parent.direction.normalized().z
	parent.velocity = parent.velocity.lerp(parent.velocity, walking_acceleration * delta)
	parent.move_and_slide()
	
	# rotate mesh
	var target_rotation = atan2(parent.direction.x, parent.direction.z) - parent.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, parent.rotation_speed * delta)
	
	if is_falling:
		return process_state_change(falling_state)
	return null
