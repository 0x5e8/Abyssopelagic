# nhu con cac db
extends CharacterBody3D
#var LineDrawer = preload("res://script/boids/line.gd").new()
@export var speed = 8

var rayDirs=BoidsUtil.new().DetectionRayDirs()
#@export var ray_root: RayCast3D
@export var detection_range = 10
@export var obj_avoidance_dist = 5
var raysArr = []
var steerForce=5
var avoidanceDist = 5
func _ready():
	for z in range(len(rayDirs)):
		var r = RayCast3D.new()
		r.target_position = rayDirs[z]*detection_range
		self.add_child(r)
		raysArr.append(r)
func rotate_to(target,w):
	var o_rot = rotation
	look_at(target)
	var n_rot = rotation 
	rotation = lerp(o_rot,n_rot,w)
func steer_toward(dir):
	var steer = dir - velocity 
	steer = steer.normalized() * steerForce
	return steer 
func _physics_process(delta):
	var forward_velocity =  -get_global_transform().basis.z
	var forward = global_position - get_global_transform().basis.z
	var c_r = 0

	var u_obs_dist = 0
	var avoid_vect = Vector3.ZERO
	for ray in range(len(rayDirs)):
		var indvRay = raysArr[ray]
		indvRay.position = $"root".position
		indvRay.rotation = $"root".rotation
		var dir = (indvRay.target_position + indvRay.position + position) # no
		#print(dir)
		
		var dist = indvRay.global_position.distance_to(indvRay.get_collision_point())
		if indvRay.is_colliding():
			if dist > u_obs_dist:
				#c_r = ray
				#print(dist," ", u_obs_dist)
				#u_obs_dist = dist
				#forward = dir
				u_obs_dist = dist+obj_avoidance_dist #wth
				avoid_vect = indvRay.get_collider().global_position - indvRay.global_position
				forward -= avoid_vect.normalized()

			#if dist < u_obs_dist  :
		else:
			pass
			#avoid_vect = forward
			#forward = avoid_vect
			#idk how tho, suggest thoi dung rewrite :<


	rotate_to(forward,0.05)
	
	#velocity = steer_toward(forward_velocity*speed) #no
	velocity =  forward_velocity * speed
	move_and_slide()
