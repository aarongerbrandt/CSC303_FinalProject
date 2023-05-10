extends Spatial

export(float) var time_to_room_stop = 10
export(int) var number_of_rooms = 25
export(int) var room_placement_radius = 30

onready var room_generator = $RoomGenerator

# const Delaunator = preload("res://Resources/Scripts/Delaunator.gd")
const Line3D = preload("res://Resources/Scripts/Line3D.gd")
const Util = preload("res://Resources/Scripts/GeneratorUtil.gd")
const Room1 = preload("res://Resources/Rooms/Room1.tscn")
const BEGINNING_HEIGHT = 0
const TILE_SIZE = 4

var points = []

func generate():
	randomize()
	for i in range(number_of_rooms):
		var room_position = Util.getRandom3DPointInCircle(room_placement_radius, TILE_SIZE)
		place_room(room_position)
	
	yield(get_tree().create_timer(time_to_room_stop), "timeout")
	room_generator.stop_rooms(points)
	
	var path = generateMST()
	
	var bridge_connections = []
	
	# Maybe use a map to map points to connections?
	for p in path.get_points():
		for c in path.get_point_connections(p):
			var connected_points = []
			var connection = PoolVector3Array()
#			var connection2 = PoolVector3Array()
			for p_conn in path.get_point_connections(p):
				var point = path.get_point_position(p_conn)
				connection.append(point)
				connected_points.append(point)
			for c_conn in path.get_point_connections(c):
				var point = path.get_point_position(c_conn)
				connection.append(point)
				connected_points.append(point)
			bridge_connections.append(connection)
			$Lines.add_child(Line3D.DrawLine(connected_points))
	
	room_generator.build_bridges(bridge_connections)

func place_room(room_position: Vector3) -> void:
	room_generator.generate_room(room_position)

func generateMST() -> AStar:
	# Create copy of list of points
	var nodes = points.duplicate()
	
	# Create new path with a single point from the list
	var path = AStar.new()
	path.add_point(
		path.get_available_point_id(), 
		nodes.pop_front()
	)
	
	# For each point in the path, 
	# get closest point that isn't in the path yet
	while nodes:
		var min_dist = INF		# Distance from current path point to node
		var min_p = null		# Closest point not in path
		var p = null 			# Point in path
		
		for p1 in path.get_points():
			p1 = path.get_point_position(p1)
			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1
		
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		# Now that node is in path, remove it from nodes
		nodes.erase(min_p)
	
	return path
