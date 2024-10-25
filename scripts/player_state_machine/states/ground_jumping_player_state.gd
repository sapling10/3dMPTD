extends State

@export var idle_state: State
@export var walking_state: State
@export var running_state: State
#@export var falling_state: State

@export var mesh_root: Node3D
@export var rotation_speed: float = 8

@export var jump_height: float = 3.75
@export var jump_peak_time: float = 0.45
@export var jump_walking_speed: float = 4.0
@export var jump_acceleration: float = 6.0

@onready var player: Player = $"../.."

var movement_direction: Vector3
var jump_gravity: float
var jump_velocity: float

func calculate_jump_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	jump_velocity = jump_gravity * jump_peak_time

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
		#if is_jumping and parent.is_on_floor():
			#return process_state_change(ground_jumping_state)
		if not is_walking:
			return process_state_change(idle_state)
		
	movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
	movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
	return null
	
func process_physics(delta: float) -> State:
	var just_jumped = Input.is_action_just_pressed("jump")
	var is_on_floor = parent.is_on_floor()
	
	if just_jumped and is_on_floor:
		parent.velocity.y = jump_velocity
		
	#if parent.velocity.y < 0:
		#return process_state_change(falling_state)
	
	#parent.velocity.x = jump_walking_speed * parent.direction.normalized().x
	#parent.velocity.z = jump_walking_speed * parent.direction.normalized().z
	parent.velocity.y -= jump_gravity * delta
	#player.velocity = player.velocity.lerp(parent.velocity, jump_acceleration * delta)
	player.move_and_slide()
	
	# rotate mesh
	var target_rotation = atan2(parent.direction.x, parent.direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)

	#if is_on_floor and not just_jumped:
		#print("im the reason")
		#return process_state_change(idle_state)
	return null
