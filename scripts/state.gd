class_name State
extends Node

#@export
#var animation_name: String
#@export
#var animation_speed: float = 1.5

var run_speed:                    float = 8.2
var fall_gravity:                 float = 25.0
var jump_gravity:                 float = 5.0
var terminal_velocity:            float = -60.0

var parent: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_state_change(state_togo: State) -> State:
	var state_name = (state_togo.name).replace("PlayerState", "")
	#parent.animation_player_state_machine.travel(state_name)
	return state_togo

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
