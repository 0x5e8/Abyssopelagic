extends CharacterBody3D

const MAX_SPEED = 5.0
const MAX_ROTATING_SPEED = 0.005

var rotating_speed = 0.0

var user: Node3D

var elapsed_time = 0.0

var camera = []
var relative_cam_rot = []
@onready var cam_pos = $camera_pos.get_children()

var headlight_shown = true
@onready var default_headlight_energy = $headlight.light_energy

var selected_cam = 0
func change_camera(id):
	if id >= len(camera) or id < 0:
		return
	
	camera[selected_cam].current = false
	camera[id].current = true
	selected_cam = id
	$camera_viewport/cam_name.text = camera[id].name
	
	var viewport = $camera_viewport.get_texture()
	$tv.mesh.material.set_shader_parameter("tv_texture", viewport)

func _ready():
	# initiate cameras info
	for child in $camera_viewport.get_children():
		if not (child is Camera3D): continue
		camera.append(child)
		relative_cam_rot.append(child.rotation)
	
	change_camera(0)

func _physics_process(delta):
	# update cameras' position
	for id in range(len(camera)):
		camera[id].position = cam_pos[id].global_position
		camera[id].rotation = relative_cam_rot[id] + self.rotation

	
	elapsed_time += delta
	# rotate top camera
	$camera_viewport/top.rotation.y += PI * sin(elapsed_time * 0.155)
	
	$IRlight.global_rotation = camera[selected_cam].global_rotation
	$IRlight.global_position = camera[selected_cam].global_position
	
	if Input.is_action_just_pressed("light"):
	# in vulkan renderer just do $headlight.visible = not $headlight.visible
	# but opengl renderer is fucking broken and will yield a fucking annoying bug
	# here's the hack: just set the light energy to 0 to "disable" the light instead
	# i wasted 5hrs to figure this out
	# fuck my life
	# p.s: anything that really hide the light from the camera (i.e changing visual layer) will not work
		if $headlight.light_energy == 0:
			$headlight.light_energy = default_headlight_energy
		else:
			$headlight.light_energy = 0

	var input_dir = Vector3.ZERO
	var y_dir = 0

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
		rotating_speed = lerp(rotating_speed, sign(rot) * MAX_ROTATING_SPEED, 0.01)
	else:
		rotating_speed = lerp(rotating_speed, 0.0, 0.01)
	rotation.y += rotating_speed

	if not $interior/pilot_room/seat.used:
		user = null
		Global.piloting = false
	else:
		Global.piloting = true
	if user:
		user.global_position = $interior/pilot_room/seat/seat_point.global_position

func _on_seat_when_use(usr):
	user = usr
