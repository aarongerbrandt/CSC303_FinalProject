extends RigidBody

var dimensions: Vector3
var position: Vector3

func load_position(position: Vector3, dimensions: Vector3):
	# Set position of room
	self.dimensions = dimensions
	self.position = position
	
	_load_collision_shape()
	_load_mesh_instance()
	
	global_translation = position

func _load_collision_shape():
	# Create shape with given dimensions
	var shape = BoxShape.new()
	shape.extents = dimensions / 2
	$CollisionShape.shape = shape

func _load_mesh_instance():
	var mesh_material = SpatialMaterial.new()
	mesh_material.albedo_color = Color.red
	var mesh = CubeMesh.new()
	mesh.material = mesh_material
	mesh.size = dimensions
	
	$MeshInstance.mesh = mesh
