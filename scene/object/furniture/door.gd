extends Node

const OPEN_ANGLE = PI * 3/5
const OPEN_SPEED = 0.08

@onready var parent = get_parent()
var rotating = false

@onready var default_rot = parent.rotation
var target_rot

func when_use(user):
	if parent.rotation == target_rot:
		target_rot = default_rot
		rotating = true
		return
	
	var from_dir = parent.get_node("dir").global_position - parent.global_position
	var from_user = user.global_position - parent.global_position
	var dot = from_dir.dot(from_user)
	
	target_rot = default_rot
	if dot >= 0:
		target_rot.y += OPEN_ANGLE
	else:
		target_rot.y -= OPEN_ANGLE

	rotating = true

func _physics_process(delta):
	if rotating:
		parent.rotation = lerp(parent.rotation, target_rot, OPEN_SPEED)
		if abs(parent.rotation.y - target_rot.y) <= 0.01:
			parent.rotation = target_rot
			rotating = false
			parent.used = false
			
			parent.message_when_look = "f to close"
			
			if target_rot == default_rot:
				target_rot = Vector3.ZERO
				parent.message_when_look = "f to open"
