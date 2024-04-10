@tool
extends Node

# tailIK's target is tail_target
# tail_target is placed into target_container so that it will not change position when rotate root
# tail_target then follow tail_pos to create the delay swing effect

@onready var tail_target = $target_container/tail_target
@onready var tail_relative = $armature/tail_pos

@export var swinging = false
@export var swing_power = 0.5
@export var swing_speed = 3.0
@export_range (0.0, 1.0) var swing_sensitivity = 0.5
var progress = 0.0

func _ready():
	$armature/Skeleton3D/tailIK.start()

func _process(delta):
	tail_target.global_position = lerp(tail_target.global_position, tail_relative.global_position, swing_sensitivity)
	
	if swinging:
		progress += delta
		$armature.rotation.y = swing_power * sin(swing_speed * progress)
