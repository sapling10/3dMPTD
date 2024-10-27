extends State

# TODO : weird bug when transitioning from jump->fall where velocity=0 and playing falls straight down

@export var idle_state: State
@export var walking_state: State
@export var running_state: State
@export var ground_jumping_state: State

@export var mesh_root: Node3D
@export var falling_walking_speed: float = 4.0
@export var falling_running_speed: float = 7.0
@export var falling_acceleration: float = 6.0
@export var terminal_velocity: float = -60.0
@export var falling_gravity: float = 12.0

var movement_direction: Vector3
var falling_speed: float

func enter() -> void:
	var is_sprinting = Input.is_action_pressed("sprint")
	if is_sprinting: 
		falling_speed = falling_running_speed
	else:
		falling_speed = falling_walking_speed
	#movement_direction = parent.direction

func process_input(event: InputEvent) -> State:
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	return null
	
func process_physics(delta: float) -> State:
	# set player direction
	parent.direction = movement_direction.rotated(Vector3.UP, parent.cam_rotation)
	# set player velocity, used ready func to get speed
	parent.velocity.x = falling_speed * parent.direction.normalized().x
	parent.velocity.z = falling_speed * parent.direction.normalized().z
	# set y vel based on term vel
	if parent.velocity.y > terminal_velocity:
		parent.velocity.y -= falling_gravity * delta
	if parent.velocity.y < terminal_velocity:
		parent.velocity.y = terminal_velocity
	parent.velocity = parent.velocity.lerp(parent.velocity, falling_acceleration * delta)
	parent.move_and_slide()
	
	# rotate mesh, free
	if movement_direction.length() > 0:
		var target_rotation = atan2(parent.direction.x, parent.direction.z) - parent.rotation.y
		mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, parent.rotation_speed * delta)
	
	var is_on_floor = parent.is_on_floor()
	# all input is predetermined on landing
	var is_walking = Input.is_action_pressed("movement")
	var is_running = Input.is_action_pressed("sprint")
	var is_jumping = Input.is_action_pressed("jump")
	
	if is_on_floor:
		if is_walking and not is_running:
			return process_state_change(walking_state)
		if is_walking and is_running:
			return process_state_change(running_state)
		if is_jumping and parent.is_on_floor():
			return process_state_change(ground_jumping_state)
		if not is_walking:
			return process_state_change(idle_state)
	return null
