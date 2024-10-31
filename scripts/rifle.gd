extends Node3D

var yaw = 0

func _process(delta: float):
	rotation.y = yaw

func _on_camera_set_cam_rotation(_cam_rotation: float) -> void:
	yaw = _cam_rotation
