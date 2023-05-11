extends Spatial

export(Vector3) var p1 = Vector3(1, 0, 1)
export(Color) var p1_color = Color.cornflower
export(Vector3) var p2 = Vector3(8, 8, 8)
export(Color) var p2_color = Color.coral

export(Color) var bridge_color = Color.rebeccapurple

export(Vector3) var rotation_axis = Vector3.ONE

func _ready():
	showPoints()
	
	drawBridge(p1, p2)

func showPoints():
	# Create CSG Boxes to show where the points are
	var csg1 = CSGBox.new()
	add_child(csg1)
	var csg2 = CSGBox.new()
	add_child(csg2)
	
	csg1.global_translation = p1
	csg2.global_translation = p2
	
	var material1 = SpatialMaterial.new()
	material1.albedo_color = p1_color
	
	var material2 = SpatialMaterial.new()
	material2.albedo_color = p2_color
	
	csg1.material = material1
	csg1.width = 2
	csg1.height = 2
	csg1.depth = 2
	
	csg2.material = material2
	csg2.width = 2
	csg2.height = 2
	csg2.depth = 2

func _get_distance(p1: Vector3, p2: Vector3) -> float:
	return p1.distance_to(p2)

func _get_angle(p1: Vector3, p2: Vector3) -> float:
	return p1.angle_to(p2)

func _get_vertical_angle(p1: Vector3, p2: Vector3) -> float:
	var a = sqrt((p1.z * p1.z) + (p1.x * p1.x))
	var c = p1.distance_to(p2)
	
	return cos(a / c)

func _get_midpoint(p1: Vector3, p2: Vector3) -> Vector3:
	return (p1 + p2) / 2

func drawBridge(p1: Vector3, p2: Vector3) -> void:
	var meshInstance = MeshInstance.new()
	var cubeMesh = CubeMesh.new()
	
	var staticBody = StaticBody.new()
	staticBody.add_child(meshInstance)
	add_child(staticBody)
	
	var distance = _get_distance(p1, p2)
	var angle = _get_angle(p1, p2)
	var vertical_angle = _get_vertical_angle(p1, p2)
	var midpoint = _get_midpoint(p1, p2)
	
	var bridgeMaterial = SpatialMaterial.new()
	bridgeMaterial.albedo_color = bridge_color
	cubeMesh.material = bridgeMaterial
	
	cubeMesh.size = Vector3(2, 2, distance)
	meshInstance.mesh = cubeMesh
	staticBody.look_at_from_position(midpoint, p2, Vector3.UP)
