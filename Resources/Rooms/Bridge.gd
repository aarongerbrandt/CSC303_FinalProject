extends StaticBody

export(int) var bridge_width = 25
export(int) var bridge_height = 2

var p1: Vector3
var p2: Vector3
var midpoint: Vector3

var length: float

const BridgeSegment = preload("res://Resources/DungeonSegments/BridgeSegment.tscn")

# TODO: Might be being called twice, just with p1 and p2 switched
func init(point_one: Vector3, point_two: Vector3) -> void:
#	_create_bridge_materials()
	
	p1 = point_one
	p2 = point_two
	
	midpoint = (p1 + p2) / 2
	look_at_from_position(midpoint, p2, Vector3.UP)
	
	length = p1.distance_to(p2)
#	$MeshInstance.mesh.size = Vector3(bridge_width, bridge_height, length)
	
	_place_segments()

func _place_segments(): # length of 35
#	print("Placing segments!")
	var segment_length = BridgeSegment.instance().dimensions.z * 0.9
	var num_segments = ceil(length / segment_length)
	
	var stretched_segment_length = ceil(length / num_segments)
	var segment_scale = stretched_segment_length / segment_length
	
	for i in range(num_segments):
		var segment = BridgeSegment.instance()
		$Segments.add_child(segment)
		
		var segment_location = p1.move_toward(p2, segment_length * i)
		
		segment.global_translation = segment_location
		segment.scale = Vector3(segment.scale.x, segment.scale.y, segment.scale.z * segment_scale)

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
