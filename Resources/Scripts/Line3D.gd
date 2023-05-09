extends Node2D
class_name Line3D

const LINE_RESOLUTION = 3
const LINE_RADIUS = .75

static func DrawLine(points: Array):
	var line = Spatial.new()
	
	var path = Path.new()
	path.name = "path"
	for p in points:
		#print("Point: %s" % str(p))
		
		path.curve.add_point(p)	
		var csg = CSGBox.new()
		csg.width = 50
		csg.height = 50
		csg.depth = 50
		csg.global_translation = p
	
		var material = SpatialMaterial.new()
		material.albedo_color = Color.green
		
		csg.material = material
		line.add_child(csg)
	
	var csg = CSGPolygon.new()
	csg.polygon.resize(0)
	csg.mode = CSGPolygon.MODE_PATH
	csg.path_node = "../path"
	
	var material = SpatialMaterial.new()
	material.albedo_color = Color.red
	
	csg.material = material
	
	var circle = PoolVector2Array()
	for degree in LINE_RESOLUTION:
		var coords = Vector2(
			LINE_RADIUS * sin(PI * 2 * degree / LINE_RESOLUTION),
			LINE_RADIUS * cos(PI * 2 * degree / LINE_RESOLUTION)
		)
		circle.append(coords)
	csg.polygon = circle
	
	line.add_child(path)
	line.add_child(csg)
	
	return line
