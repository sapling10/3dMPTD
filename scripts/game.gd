extends Node3D

@onready var player: Player = $Player

func _physics_process(delta: float):
	# enemies just target the player currently
	get_tree().call_group("enemies", "update_target_location", player.global_transform.origin)
