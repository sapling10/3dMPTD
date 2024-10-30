extends CharacterBody3D
class_name Player

signal set_health(_health: float)

@onready var animation_player: AnimationPlayer = $Visuals/AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var player_state_machine: Node = $MovementStateMachine
@onready var mesh_root: Node3D = $Visuals

@export var health: float = 100
@export var rotation_speed: float = 8

var coyote_time: float = 0.25
@onready var coyote_timer: Timer = $CoyoteTimer


var animation_player_state_machine
var direction: Vector3 # current facing direction
var prev_movement_direction: Vector3 # previous movement input
var camera_rotation: float
var jump_available: bool = true


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

func coyote_timeout():
	jump_available = false

# testing
func _input(event: InputEvent):
	if event.is_action_pressed("DEBUG_damage_player"):
		health = health - 10
		if (health < 0): health = 0
		set_health.emit(health)
	if event.is_action_pressed("DEBUG_heal_player"):
		health = health + 10
		if (health > 100): health = 100
		set_health.emit(health)
	if event.is_action_pressed("DEBUG_heavy_damage_player"):
		health = health - 25
		if (health < 0): health = 0
		set_health.emit(health)
	if event.is_action_pressed("DEBUG_heavy_heal_player"):
		health = health + 25
		if (health > 100): health = 100
		set_health.emit(health)
