extends Node
class_name BoidsUtil
var rayCount = 100


func DetectionRayDirs():
	var dirs: PackedVector3Array
	for k in range(rayCount):dirs.append(Vector3(0,0,0))
	var Phi = (1 + sqrt (5)) / 2
	var angleIncr = 2*PI*Phi
	for i in range(rayCount):
		var t = float(i)/rayCount
		var inclination = acos(1 - 2*t)
		var azimuth = angleIncr + i 
		var x = sin(inclination)*cos(azimuth)
		var y = sin(inclination)*sin(azimuth)
		var z = cos(inclination)
		if x > 0:x = -x
		dirs[i]= Vector3(
		   x,y,z
		)
	return dirs

