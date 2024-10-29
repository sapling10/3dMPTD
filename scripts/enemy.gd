extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var player_detection_area: Area3D = $PlayerDetectionArea

var SPEED = 3.0
var player_detected = false
var target_position = Vector3.ZERO

func _physics_process(delta: float):
	# get next location
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	nav_agent.set_velocity(new_velocity) # calc adjusted velocity for avoidance

func update_target_location(target_location):
	nav_agent.target_position = target_location
	#if player_detected:
	#	nav_agent.target_position = target_location
	#else:
	#	nav_agent.target_position = Vector3(0,1,0)


func _on_navigation_agent_3d_target_reached() -> void:
	#print("In range")
	pass


func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
