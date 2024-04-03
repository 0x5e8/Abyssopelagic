extends CharacterBody3D
var LineDrawer = preload("res://model/object/boids/line.gd").new()
var speed = 5

var detection_range=1
var rayDirs=BoidsUtil.new().DetectionRayDirs()

func _ready():
	for z in range(BoidsUtil.new().rayCount):
		#$"normal-fish".add_child(LineDrawer)
		pass
		
func _physics_process(delta):
	var forward=$"normal-fish/fishe_vision".get_global_transform().basis.z
	var rayPosRoot=$"normal-fish/fishe_vision".global_position
	var sp_state = get_world_3d().direct_space_state
	
	for k in range(len(rayDirs)):
		pass
		
		var maxdist = Vector3(0,0,0)
		var rayQuery = PhysicsRayQueryParameters3D.create(rayPosRoot,  $"normal-fish/target".global_position + detection_range*rayDirs[k])
		rayQuery.exclude = [self]
		var rayQuery_intersect = sp_state.intersect_ray(rayQuery)	
		#don't uncomment this line while having high number of viewing directions otherwise u'll become ambatukam
		#LineDrawer.DrawLine(rayPosRoot, $"normal-fish/target".global_position + detection_range*rayDirs[k], Color(0, 0, 1), 0.01)
		if rayQuery_intersect:
			#stupid
			#print(global_position-rayQuery_intersect.position)
			if abs(global_position-rayQuery_intersect.position) > maxdist:
				look_at(rayDirs[k]*delta)
				maxdist = rayDirs[k]
			#rotation.y+=0.01
	velocity=forward*speed
	
	move_and_slide()
