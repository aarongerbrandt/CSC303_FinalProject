extends Spatial

export(float) var time_to_room_stop = 10
export(float, 0, 2) var spread_magnitude = 0.25
export(int) var number_of_rooms = 25
export(int) var room_placement_radius = 30
export(int, 1, 30) var min_room_size = 15
export(int, 31, 75) var max_room_size = 20

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
	_stop_rooms()
	
	var path = generateMST()
	
	for p in path.get_points():
		for c in path.get_point_connections(p):
			var connected_points = []
			for cp in path.get_point_connections(p):
				connected_points.append(path.get_point_position(cp))
			for cp in path.get_point_connections(c):
				connected_points.append(path.get_point_position(cp))
			add_child(Line3D.DrawLine(connected_points))

func place_room(room_position: Vector3) -> void:
	var room_dimensions = Vector3(
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size)
	)
	
	var room = Room1.instance()
	room.load_position(room_position, room_dimensions)
	$Rooms.add_child(room)

func _stop_rooms():
	for room in $Rooms.get_children():
		if room:
			# After spreading apart, amplify their distance by a certain threshold
			room.spread(spread_magnitude)
			
			room.mode = RigidBody.MODE_STATIC
			points.append(room.get_center()) # Util.v3_to_v2(room.get_center())


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
