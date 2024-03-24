extends Node
class_name Item

var used = false
signal when_use

func _init():
	when_use.connect(emitted)

func emitted(_a):
	used = !used
