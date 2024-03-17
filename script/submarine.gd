extends CharacterBody3D

const ACCELERATION = 0.5
const STOP_ACCELERATION = 0.6
const MAX_SPEED = 3.0

const ROTATING_ACCELERATION = 0.01
const STOP_ROTATING_ACCELERATION = 0.01
const MAX_ROTATING_SPEED = 0.01

var rotating_speed = 0.0

func _physics_process(delta):
	var input_dir = Input.get_vector("backward", "forward", "left", "right")

	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	if direction:
		direction.y = 0
		velocity = (velocity + direction * ACCELERATION * delta).limit_length(MAX_SPEED)
	else:
		direction = velocity.normalized()
		velocity = velocity - direction * STOP_ACCELERATION * delta
	move_and_slide()

	var rot = -input_dir.y
	if rot != 0:
		var sign = 1 if rot > 0 else -1
		rotating_speed = move_toward(rotating_speed, sign * MAX_ROTATING_SPEED, abs(rot) * ROTATING_ACCELERATION * delta)
	else:
		rotating_speed = move_toward(rotating_speed, 0.0, STOP_ROTATING_ACCELERATION * delta)
	rotation.y += rotating_speed
