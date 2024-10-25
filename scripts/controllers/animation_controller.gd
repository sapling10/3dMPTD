extends Node

@export var animation_tree: AnimationTree
@export var player: CharacterBody3D
var animation_player_state_machine

func _ready() -> void:
	animation_player_state_machine = animation_tree["parameters/playback"]

func _jump(jump_state: JumpState):
	animation_player_state_machine.travel(jump_state.animation_name)



func _on_set_movement_state(_movement_state: MovementState):
	animation_player_state_machine.travel(_movement_state.animation_name)


func _is_falling(fall_state: FallState) -> void:
	animation_player_state_machine.travel(fall_state.animation_name)
