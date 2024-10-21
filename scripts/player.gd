extends CharacterBody3D

var inputdir = Vector3()
var direction = Vector3()
var vertical_velocity = Vector3()
var turn_speed = 10
var root_velocity = Vector3()
var horizontal = float()
var vertical = float()
@export
var animation_tree: AnimationTree
@export
var animation_player: AnimationPlayer
@onready
var animation_state = animation_tree.get("parameters/playback")
var anim_canmove = bool()

@export
var camera_target: Node3D
@export
var camera_parent: Node3D
var camera_T = float()
var cam_speed = float()

func _process(delta):
	horizontal = Input.get_axis("right", "left")
	vertical = Input.get_axis("backward", "forward")
	
	var root_pos = animation_tree.get_root_motion_position()
	var current_rotation = (animation_tree.get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_pos / delta
	var root_rotation = animation_tree.get_root_motion_rotation()
	set_quaternion(get_quaternion() * root_rotation)

func _physics_process(delta: float):
	animation_tree.set("parameters/conditions/move", anim_canmove)
	animation_tree.set("parameters/conditions/idle", !anim_canmove)
	
	
	inputdir = Vector3(horizontal, 0, vertical).normalized()
	
	if (inputdir != Vector3.ZERO):
		anim_canmove = true
	else:
		anim_canmove = false
	
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), turn_speed * delta)
	
	velocity = root_velocity
	move_and_slide()
