extends Spatial

export(Vector3) var p1 = Vector3(1, 0, 1)
export(Color) var p1_color = Color.cornflower
export(Vector3) var p2 = Vector3(8, 8, 8)
export(Color) var p2_color = Color.coral

export(Color) var bridge_color = Color.rebeccapurple

export(Vector3) var rotation_axis = Vector3.ONE

const Bridge = preload("res://Resources/Rooms/Bridge.tscn")

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

func drawBridge(p1: Vector3, p2: Vector3) -> void:
	var bridge = Bridge.instance()
	add_child(bridge)
	bridge.init(p1, p2)
