extends State

@export var idle_state: State
@export var walking_state: State
@export var running_state: State
@export var falling_state: State

@export var mesh_root: Node3D
@export var jump_height: float = 4
@export var jump_peak_time: float = .6
@export var jump_walking_speed: float = 4.0
@export var jump_running_speed: float = 7.0
@export var jump_acceleration: float = 6.0

var movement_direction: Vector3
var jump_gravity: float
var jump_velocity: float


func enter():
	parent.velocity.y = 2 * jump_height / jump_peak_time
	jump_gravity = parent.velocity.y / jump_peak_time
	movement_direction = parent.prev_movement_direction
	#print("\tSETTING IN JUMPING - move_dir: ", movement_direction)

func exit():
	#print("\tFROM JUMPING - prev_move now: ", movement_direction)
	parent.prev_movement_direction = movement_direction

func process_input(event: InputEvent) -> State:
	#print("jumping | movement_direction=", movement_direction)
	return null
	
func process_physics(delta: float) -> State:
	var is_sprinting = Input.is_action_pressed("sprint")
	
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	# set player direction
	parent.direction = movement_direction.rotated(Vector3.UP, parent.camera_rotation)
	#print("jumping | parent.direction=", parent.direction)
	# set player velocity
	if not is_sprinting:
		parent.velocity.x = jump_walking_speed * parent.direction.normalized().x
		parent.velocity.z = jump_walking_speed * parent.direction.normalized().z
	else:
		parent.velocity.x = jump_running_speed * parent.direction.normalized().x
		parent.velocity.z = jump_running_speed * parent.direction.normalized().z
	# set y vel based on term vel
	if parent.velocity.y >= 0:
		parent.velocity.y -= jump_gravity * delta
	else:
		return process_state_change(falling_state)
	parent.velocity = parent.velocity.lerp(parent.velocity, jump_acceleration * delta)
	parent.move_and_slide()
	
	# rotate mesh, free
	if movement_direction.length() > 0:
		parent.set_mesh_rotation(delta)
		
	return null
