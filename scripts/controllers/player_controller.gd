extends CharacterBody3D
class_name Player

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)
signal pressed_jump(jump_state: JumpState)
signal is_falling(fall_state: FallState)


@export var movement_states: Dictionary
@export var jump_states: Dictionary
@export var fall_states: Dictionary

@onready var ramp_fall_ray_cast: RayCast3D = $RampFallRayCast

var is_jumping = false
var movement_direction: Vector3

func _input(event: InputEvent):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("left") - Input.get_action_strength("right")
		movement_direction.z = Input.get_action_strength("forward") - Input.get_action_strength("backward")
		if is_on_floor():
			is_jumping = false
			if is_movement_ongoing():
				if Input.is_action_pressed("sprint"):
					set_movement_state.emit(movement_states["run"])
				else:
					set_movement_state.emit(movement_states["walk"])
			else:
				set_movement_state.emit(movement_states["idle"])
			
	elif event.is_action("jump") and is_on_floor():
		is_jumping = true
		pressed_jump.emit(jump_states["groundjump"])

func _ready():
	set_movement_direction.emit(Vector3.BACK)
	set_movement_state.emit(movement_states["idle"])

func _physics_process(delta: float):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	
	if !is_on_floor() and not is_jumping:
		is_falling.emit(fall_states["fall"])

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
