extends Node
class_name Item

var used = false
signal when_use

@export var message_when_look = "f to use"
@export var callback_object: Node

func _init():
	when_use.connect(emitted)

func emitted(_a):
	used = !used
	if callback_object:
		callback_object.when_use(_a)
