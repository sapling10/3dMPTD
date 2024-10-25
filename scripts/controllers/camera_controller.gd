extends Node3D
class_name CameraController

signal set_cam_rotation(_cam_rotation: float)

@export var player: Player

@onready var cam_yaw: Node3D = $CamYaw
@onready var cam_pitch: Node3D = $CamYaw/CamPitch
@onready var camera: Camera3D = $CamYaw/CamPitch/SpringArm3D/Camera3D
@onready var spring_arm: SpringArm3D = $CamYaw/CamPitch/SpringArm3D

var yaw: float = 0
var pitch: float = 0
var yaw_sensitivity: float = 0.07
var pitch_sensitivity: float = 0.07
var yaw_acceleration: float = 15
var pitch_acceleration: float = 15
var pitch_max: float = 60
var pitch_min: float = -80

var tween: Tween

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity
		
func _physics_process(delta: float):
	pitch = clamp(pitch, pitch_min, pitch_max)
	cam_yaw.rotation_degrees.y = lerp(cam_yaw.rotation_degrees.y, yaw, yaw_acceleration * delta)
	cam_pitch.rotation_degrees.x = lerp(cam_pitch.rotation_degrees.x, pitch, pitch_acceleration * delta)
	
	set_cam_rotation.emit(cam_yaw.rotation.y)
	
# TODO : reimplement fov tween
#func _on_set_movement_state(_movement_state: MovementState):
#	if tween:
#		tween.kill()
#	
#	tween = create_tween()
#	tween.tween_property(camera, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
