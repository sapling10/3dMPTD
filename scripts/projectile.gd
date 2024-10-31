extends Node3D



@export var speed = 65.0
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var ray_cast: RayCast3D = $RayCast3D

func _process(delta: float):
	position += transform.basis * Vector3(0, 0, -speed) * delta


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	print(body.name)
