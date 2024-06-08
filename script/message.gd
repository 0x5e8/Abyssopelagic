extends Label

func _process(delta):
	visible = not Input.is_action_pressed("zoom")
	text = Global.displaying_message
