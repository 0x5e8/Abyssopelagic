@tool
extends Marker3D

@export var ray: RayCast3D
@export var parent: Node3D

func _process(delta):
	global_position = ray.global_position + ray.target_position * ray.basis
