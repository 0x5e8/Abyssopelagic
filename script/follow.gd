extends Node3D

@export var target: Node3D
@export var pivot: Node3D

var relative_position: Vector3
var relative_rotation: Vector3

func _ready():
	relative_rotation = self.rotation - target.rotation
	relative_position = self.position - pivot.position

func _physics_process(delta):
	self.position = lerp(self.position, pivot.global_position + relative_position, 0.07)
	self.rotation = lerp(self.rotation, target.rotation + relative_rotation, 0.1)
