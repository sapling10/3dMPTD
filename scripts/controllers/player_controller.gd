extends CharacterBody3D
class_name Player

@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player_state_machine: Node = $PlayerStateMachine
@onready var mesh_root: Node3D = $Visuals
@export var rotation_speed: float = 8

var animation_player_state_machine
# for walking the cameras direction
var direction: Vector3 # current facing direction
var prev_movement_direction: Vector3 # previous movement input
var camera_rotation: float
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

func _on_camera_set_cam_rotation(_cam_rotation: float) -> void:
	camera_rotation = _cam_rotation

func set_mesh_rotation(delta: float):
	# rotate mesh
	var target_rotation = atan2(direction.x, direction.z) - rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
