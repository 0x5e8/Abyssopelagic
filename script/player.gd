extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# rotate camera and player in the way that `point` in viewport now in the center of the viewport
func player_look_at(point):
	var w = get_viewport().get_visible_rect().size.x
	var f = (w/2) * tan($camera.fov/2)
	
	self.rotation.y += atan(point.x/f)
	$camera.rotation.x += atan(point.y/f)

# mouse input
func _input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		player_look_at(event.relative * sensitivity)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
