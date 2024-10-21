extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var movement_state: Dictionary

var movement_direction: Vector3

func _input(event: InputEvent):
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		movement_direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	
		if is_movement_ongoing():
			if Input.is_action_pressed("sprint"):
				set_movement_state.emit(movement_state["run"])
			else:
				set_movement_state.emit(movement_state["walk"])
		else:
			set_movement_state.emit(movement_state["idle"])

func _ready():
	set_movement_state.emit(movement_state["idle"])

func _physics_process(delta: float):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
