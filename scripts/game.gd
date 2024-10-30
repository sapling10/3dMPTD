extends Node3D

@onready var player: Player = $Player

# only currently responsible for enemies
# TODO : move enemy AI out of game.gd

func _physics_process(delta: float):
	# enemies just target the player currently, player.global_transform.origin
	get_tree().call_group("enemies", "update_target_location", Vector3(0,1,0))
	
