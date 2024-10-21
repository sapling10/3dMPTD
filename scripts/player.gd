extends CharacterBody3D
class_name Player

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)
signal pressed_jump(jump_state: JumpState)

@export var movement_states: Dictionary
@export var jump_states: Dictionary

var movement_direction: Vector3

func _input(event: InputEvent):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	
		if is_movement_ongoing():
			if Input.is_action_pressed("sprint"):
				set_movement_state.emit(movement_states["run"])
			else:
				set_movement_state.emit(movement_states["walk"])
		else:
			set_movement_state.emit(movement_states["idle"])
			
	if event.is_action("jump") and is_on_floor():
		var jump_name = "groundjump"
		pressed_jump.emit(jump_states[jump_name])

func _ready():
	set_movement_direction.emit(Vector3.BACK)
	set_movement_state.emit(movement_states["idle"])

func _physics_process(delta: float):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
