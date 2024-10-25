extends State

@export var idle_state: State
@export var walking_state: State
@export var running_state: State
@export var ground_jumping_state: State

@export var mesh_root: Node3D
@export var falling_walking_speed: float = 4.0
@export var falling_acceleration: float = 6.0
@export var terminal_velocity: float = -60.0
@export var falling_gravity: float = 12.0

var movement_direction: Vector3

func process_input(event: InputEvent) -> State:
	var is_walking = Input.is_action_pressed("movement")
	var is_running = Input.is_action_pressed("sprint")
	var is_jumping = Input.is_action_pressed("jump")
	var is_on_floor = parent.is_on_floor()
	
	if is_on_floor:
		if is_walking and not is_running:
			return process_state_change(walking_state)
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
	var is_on_floor = parent.is_on_floor()
	
	if parent.velocity.y > terminal_velocity:
		parent.velocity.y += -falling_gravity * delta
	if parent.velocity.y <= terminal_velocity:
		parent.velocity.y = terminal_velocity
	
	# set player direction
	parent.direction = movement_direction.rotated(Vector3.UP, parent.cam_rotation)
	# set player velocity
	parent.velocity.x = falling_walking_speed * parent.direction.normalized().x
	parent.velocity.z = falling_walking_speed * parent.direction.normalized().z
	parent.velocity = parent.velocity.lerp(parent.velocity, falling_acceleration * delta)
	parent.move_and_slide()
	
	# rotate mesh
	var target_rotation = atan2(parent.direction.x, parent.direction.z) - parent.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, parent.rotation_speed * delta)
	
	if is_on_floor:
		return process_state_change(idle_state)
	return null
