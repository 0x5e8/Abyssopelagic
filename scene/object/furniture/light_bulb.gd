@tool
extends CSGCombiner3D

@export_color_no_alpha var color = Color(1.0, 1.0, 1.0)
@export_range(0.0, 100.0) var range = 10.0
@export_range(0.0, 100.0) var energy = 1.0

func _process(delta):
	$light.omni_range = range
	$light.light_color = color
	$light.light_energy = energy
