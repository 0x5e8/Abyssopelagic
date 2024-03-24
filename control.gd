extends Node

@onready var parent = get_node("..")
@onready var label = parent.get_node("HUD/pilot")
var exited = 0
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta):
	if Input.is_action_just_pressed("use"):
		Global.piloting = not Global.piloting
	if Input.is_action_just_pressed("exit") and not exited:
		exited=1
		parent.get_node("submarine/player").reparent($"../map")
	if Global.piloting:
		label.text = "is piloting"
	else:
		label.text = "not piloting, `f` to pilot"
