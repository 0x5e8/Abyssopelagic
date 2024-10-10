extends CharacterBody3D

const MAX_SPEED = 5.0
const MAX_ROTATING_SPEED = 0.005

var rotating_speed = 0.0

var user: Node3D

func lerp_angle_3d(from, to, weight):
	var ans = Vector3.ZERO
	ans.x = lerp_angle(from.x, to.x, weight)
	ans.y = lerp_angle(from.y, to.y, weight)
	ans.z = lerp_angle(from.z, to.z, weight)
	return ans

func _physics_process(delta):
	if Input.is_action_just_pressed("light") and Global.pilotting:
		$headlight.visible = not $headlight.visible
	
	if user:
		user.global_position = $interior/pilot_room/seat/seat_point.global_position
		
	var input_dir = Vector3.ZERO
	var y_dir = 0

	# only move and rotate when pilotting
	if Global.pilotting:
		input_dir = Input.get_vector("backward", "forward", "left", "right")
		y_dir = Input.get_axis("down", "up")

	var direction = (global_basis * Vector3(input_dir.x, y_dir, 0)).normalized()
	if direction:
		velocity = lerp(velocity, MAX_SPEED * direction, 0.05)
	else:
		velocity = lerp(velocity, Vector3.ZERO, 0.05)
	move_and_slide()

	var rot = -input_dir.y
	if rot != 0:
		rotating_speed = lerp(rotating_speed, sign(rot) * MAX_ROTATING_SPEED, 0.01)
	else:
		rotating_speed = lerp(rotating_speed, 0.0, 0.01)
	rotation.y += rotating_speed

	if not $interior/pilot_room/seat.used:
		user = null
		Global.pilotting = false
	else:
		Global.pilotting = true

func _on_seat_when_use(usr):
	user = usr
