extends Node
class_name State

@export var animation_speed: float = 1

var parent: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_state_change(state_togo: State) -> State:
	parent.animation_player_state_machine.travel(state_togo.name)
	return state_togo

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
