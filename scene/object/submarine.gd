extends CharacterBody3D

const MAX_SPEED = 5.0
const MAX_ROTATING_SPEED = 0.005

var rotating_speed = 0.0

var user: Node3D

var elapsed_time = 0.0

@onready var camera = $camera_viewport.get_children()
var relative_cam_rot = []
@onready var cam_pos = $camera_pos.get_children()

var selected_cam = 0
func change_camera(id):
	if id >= len(camera) or id < 0:
		return
	
	camera[selected_cam].current = false
	camera[id].current = true
	selected_cam = id
	
	var viewport = $camera_viewport.get_texture()
	$tv.mesh.material.set_shader_parameter("tv_texture", viewport)

func _ready():
	# initiate cameras info
	for cam in camera:
		relative_cam_rot.append(cam.rotation)
	
	change_camera(0)

func _physics_process(delta):
	# update cameras' position
	for id in range($camera_viewport.get_child_count()):
		camera[id].position = cam_pos[id].global_position
		camera[id].rotation = relative_cam_rot[id] + self.rotation

	
	elapsed_time += delta
	# rotate top camera
	$camera_viewport/top.rotation.y += PI * sin(elapsed_time * 0.155);

	var input_dir = Vector3.ZERO
	var y_dir = 0
	# Q: why doing this
	# A: to preserve momentum5
	if Global.piloting:
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
		var sign = -1 if rot < 0 else 1
		rotating_speed = lerp(rotating_speed, sign * MAX_ROTATING_SPEED, 0.01)
	else:
		rotating_speed = lerp(rotating_speed, 0.0, 0.01)
	rotation.y += rotating_speed

	if not $seat.used:
		user = null
		Global.piloting = false
	else:
		Global.piloting = true
	if user:
		user.global_position = $seat/seat_point.global_position

func _on_seat_when_use(usr):
	user = usr
