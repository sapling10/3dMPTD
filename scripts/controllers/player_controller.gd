extends CharacterBody3D
class_name Player

@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player_state_machine: Node = $PlayerStateMachine
@export var rotation_speed: float = 8

var animation_player_state_machine
# for walking the cameras direction
var direction: Vector3 # current facing direction
var cam_rotation: float = 0.0 # current camera rotation

# should handle all jumping timers here

func _ready():
	direction = Vector3.BACK
	animation_player_state_machine = animation_tree["parameters/playback"]
	player_state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	player_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	player_state_machine.process_physics(delta)
	
func _process(delta: float) -> void:
	player_state_machine.process_frame(delta)

# from States (Walking, Running)
func _on_set_movement_direction(_movement_direction: Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)

# from CameraController
func _on_set_cam_rotation(_cam_rotation: float):
	cam_rotation = _cam_rotation
