extends State

@export var walking_state: State
@export var running_state: State
@export var ground_jumping_state: State
@export var falling_state: State

var movement_direction: Vector3

func enter():
	parent.velocity.z = 0
	
func process_input(event: InputEvent) -> State:
	var is_moving = Input.is_action_pressed("movement")
	var is_running = Input.is_action_pressed("sprint")
	var is_jumping = Input.is_action_pressed("jump")
	
	if is_moving and !is_running:
		return process_state_change(walking_state)
	if is_moving and is_running:
		return process_state_change(running_state)
	if is_jumping and parent.is_on_floor():
		print("jump")
		return process_state_change(ground_jumping_state)
	if is_jumping:
		print("just is jumping")
	
	return null

func process_physics(delta: float) -> State:
	var is_on_floor = parent.is_on_floor()
	
	if not is_on_floor:
		return process_state_change(falling_state)
	return null
