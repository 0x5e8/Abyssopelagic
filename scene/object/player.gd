extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var sensitivity = 0.5

var using_item: Item

var max_cam_angle = deg_to_rad(85)

@export var message_output: Label

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func move_view(point):
	var sens = sensitivity / 100
	sens *= $camera.fov / 105.0
	
	self.rotation.y -= point.x * sens
	# prevent weird camera angle
	# comment this line to do a barrel roll
	$camera.rotation.x = clamp($camera.rotation.x - point.y * sens, -max_cam_angle, max_cam_angle)

# mouse input
func _input(event):
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	
	if event is InputEventMouseMotion:
		move_view(event.relative)

func _process(delta):
	message_output.text = ""
	
	if Input.is_action_pressed("zoom"):
		$camera.fov = lerp($camera.fov, 30.0, 0.1)
	else:
		$camera.fov = lerp($camera.fov, 75.0, 0.1)
	message_output.visible = not Input.is_action_pressed("zoom")
	
	var obj = $camera/ray.get_collider()
	if obj and obj.is_in_group("usable") and not obj.used and not using_item:
		message_output.text = obj.message_when_look
	if Input.is_action_just_pressed("use"):
		if using_item:
			using_item.when_use.emit(self)
			using_item = null
		elif obj and obj.is_in_group("usable"):
			obj.when_use.emit(self)
			if obj.is_in_group("item"):
				using_item = obj
	
	# disable collision so that the sub will move freely
	$collision.disabled = Global.piloting
	# disable movement in the cursed way
	if Global.piloting:
		return
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")

	var direction = (global_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if not is_on_floor():
		velocity.y -= gravity * delta

	move_and_slide()
