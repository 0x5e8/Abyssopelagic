extends Node

@onready var parent = get_node("..")
@onready var label = parent.get_node("HUD/pilot")

@onready var sub = parent.get_node("submarine")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if event.keycode == KEY_1:
			sub.change_camera(0)
		if event.keycode == KEY_2:
			sub.change_camera(1)
		if event.keycode == KEY_3:
			sub.change_camera(2)
		if event.keycode == KEY_4:
			sub.change_camera(3)
		if event.keycode == KEY_5:
			sub.change_camera(4)
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
