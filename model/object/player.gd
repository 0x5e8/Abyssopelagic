extends CharacterBody3D
@export var Seat: Node3D
var player_mass = 5
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var sensitivity = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func move_view(point):
	# rotate camera and player in the way that `point` in viewport now in the center of the viewport
	# however it is not efficient
	#var w = get_viewport().get_visible_rect().size.x
	#var f = (w/2) * tan($camera.fov/2)
	#
	#self.rotation.y += atan(point.x/f * sensitivity)
	#$camera.rotation.x += atan(point.y/f * sensitivity)
	
	# much simpler approach
	self.rotation.y -= point.x * sensitivity / 100
	$camera.rotation.x -= point.y * sensitivity / 100

# mouse input
func _input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		move_view(event.relative)

func _physics_process(delta):
	var input_dir = Vector3.ZERO
	var y_dir = 0

	if not Global.piloting:
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		#if not $".".is_in_group("."):
		y_dir = Input.get_axis('down',"up")
	else:
		global_position=Seat.global_position
		velocity.y=0
	var direction = (global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var idk = (global_basis * Vector3(0,y_dir,0)).normalized()
	var d_vel = gravity*delta 
	velocity.y-=d_vel 
	if direction:
		if is_on_floor():
			velocity.y = idk.y * player_mass
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		#velocity.y -= gravity*delta
	move_and_slide()
