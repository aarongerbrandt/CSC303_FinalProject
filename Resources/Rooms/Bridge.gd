extends StaticBody

export(int) var bridge_width = 25
export(int) var bridge_height = 2

var p1: Vector3
var p2: Vector3
var midpoint: Vector3

var length: float

func init(point_one: Vector3, point_two: Vector3) -> void:
	_create_bridge_materials()
	
	p1 = point_one
	p2 = point_two
	
	midpoint = (p1 + p2) / 2
	look_at_from_position(midpoint, p2, Vector3.UP)
	
	length = p1.distance_to(p2)
	$MeshInstance.mesh.size = Vector3(bridge_width, bridge_height, length)

func _create_bridge_materials():
	var mesh_mat = SpatialMaterial.new()
	mesh_mat.albedo_color = Color.rebeccapurple
	
	var cube_mesh = CubeMesh.new()
	cube_mesh.size = Vector3.ONE
	cube_mesh.material = mesh_mat
	$MeshInstance.mesh = cube_mesh

# Displays coordinates of each end, as well as length of Bridge in the scene
func _show_points():
	var p1_label = Label3D.new()
	var p2_label = Label3D.new()
	var m_label = Label3D.new()
	add_child(p1_label)
	add_child(p2_label)
	add_child(m_label)
	
	p1_label.pixel_size = 1
	p2_label.pixel_size = 1
	m_label.pixel_size = 1
	
	p1_label.text = ("(%.2f, %.2f, %.2f)" % [p1.x, p1.y, p1.z])
	p2_label.text = ("(%.2f, %.2f, %.2f)" % [p2.x, p2.y, p2.z])
	m_label.text = "%.2f" % $MeshInstance.mesh.size.z
	
	p1_label.global_translation = p1 + Vector3(0, randi() % 100, 0)
	p2_label.global_translation = p2 + Vector3(0, randi() % 100, 0)
	m_label.global_translation = midpoint + Vector3(0, 10, 0)
