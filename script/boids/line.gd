extends Node2D

class Line:
	var Start
	var End
	var LineColor
	var time
	
	func _init(Start, End, LineColor, time):
		self.Start = Start
		self.End = End
		self.LineColor = LineColor
		self.time = time

var Lines = []
var RemovedLine = false

func _process(delta):
	for i in range(len(Lines)):
		Lines[i].time -= delta
	
	if(len(Lines) > 0 || RemovedLine):
		queue_redraw() #Calls _draw
		RemovedLine = false

func _draw():
	var Cam = get_viewport().get_camera_3d()
	for i in range(len(Lines)):
		var ScreenPointStart = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd = Cam.unproject_position(Lines[i].End)
		

		if(Cam.is_position_behind(Lines[i].Start) ||
			Cam.is_position_behind(Lines[i].End)):
			continue
		
		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor)
	
	#Remove lines that have timed out
	var i = Lines.size() - 1
	while (i >= 0):
		if(Lines[i].time < 0.0):
			Lines.remove_at(i)
			RemovedLine = true
		i -= 1
func DrawLine(Start, End, LineColor, time = 0.0):
	Lines.append(Line.new(Start, End, LineColor, time))

func DrawRay(Start, Ray, LineColor, time = 0.0):
	Lines.append(Line.new(Start, Start + Ray, LineColor, time))


	
