extends RigidBody
class_name Base_Room

export (Color) var room_color = Color.red
export (Color) var collision_color = Color.blue
export (Color) var noncollision_color = Color.green

# Create 4 entrances on each room, and make connections from entrance to entrance
var dimensions: Vector3
var position: Vector3
var entrance_data = {
	"x_pos": {
		"position": null,
		"taken": false
	},
	"x_neg": {
		"position": null,
		"taken": false
	},
	"z_pos": {
		"position": null,
		"taken": false
	},
	"z_neg": {
		"position": null,
		"taken": false
	}
}

func _ready():
	pass

func load_position(position: Vector3, dimensions: Vector3):
	# Set position of room
	self.dimensions = dimensions
	self.position = position
	
#	_load_collision_shape()
#	_load_mesh_instance()
	
	global_translation = position

func get_center() -> Vector3:
	return global_transform.origin

func spread(spread_magnitude: float) -> void:	
	for body in get_colliding_bodies():
		if body.get_parent() == get_parent():
			print("Deleting: %s" % str(body))
			body.queue_free()

#func _load_collision_shape():
#	# Create shape with given dimensions
#	var shape = BoxShape.new()
#	shape.extents = dimensions / 2
#	$CollisionShape.shape = shape

#func _load_mesh_instance():
#	var mesh_material = SpatialMaterial.new()
#	mesh_material.albedo_color = room_color
#	var cube_mesh = CubeMesh.new()
#	cube_mesh.material = mesh_material
#	cube_mesh.size = dimensions
#
#	$MeshInstance.mesh = cube_mesh
