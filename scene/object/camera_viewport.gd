# keep camera fit the plane mesh
extends SubViewport

@export_range(0, 1024) var resolution: int
@export var tv: MeshInstance3D
func _ready():
	self.size = tv.mesh.size * resolution
