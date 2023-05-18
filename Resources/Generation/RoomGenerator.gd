extends Spatial

export(int, 1, 50) var min_room_size = 15
export(int, 50, 150) var max_room_size = 20
export(float) var spread_magnitude = 0.25
export(int, 0, 1000) var height_variation = 300

const Room1 = preload("res://Resources/Rooms/Room1.tscn")
const Bridge = preload("res://Resources/Rooms/Bridge.tscn")

var _bridge_connections = {}

# Removes all children for debug purposes
func clear():
	var rooms = $Rooms
	for room in rooms.get_children():
		rooms.remove_child(room)
		room.queue_free()
	
	var bridges = $Bridges
	for bridge in bridges.get_children():
		bridges.remove_child(bridge)
		bridge.queue_free()

func generate_room(room_position: Vector3) -> void:
	var room_dimensions = Vector3(
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size)
	)
	
	var room = Room1.instance()
	room.load_position(room_position, room_dimensions)
	$Rooms.add_child(room)

func stop_rooms(spread_magnitude: float) -> Array:
	var room_positions = []
	for room in $Rooms.get_children():
		if room:
			# After spreading apart, amplify their distance by a certain threshold
			room.spread(spread_magnitude)
			
			# Randomize Room Height
			room.global_translation.y = rand_range(-height_variation / 2, height_variation / 2)
			
			room.mode = RigidBody.MODE_STATIC
			room_positions.append(room.get_center()) # Util.v3_to_v2(room.get_center())
	return room_positions

# Given an array of points, creates bridges from one point to the next
#		i.e. [p1, p2, p3] creates a bridge from p1 to p2, and p2 to p3
func add_bridges2(points: Array) -> void:
#	print(points)
	for i in range(points.size() - 1):
		var p1 = points[i]
		var p2 = points[i + 1]
		
		if !_bridge_connections.has(p1):
			_bridge_connections[p1] = [p2]
			
			var bridge = Bridge.instance()
			$Bridges.add_child(bridge)
			bridge.init(p1, p2)
		else:
			var preexisting_connections = _bridge_connections[p1] as Array
			if !preexisting_connections.has(p2):
				_bridge_connections[p1].append(p2)
				var bridge = Bridge.instance()
				$Bridges.add_child(bridge)
				bridge.init(p1, p2)
			else:
				pass #print("%s already had: %s" % [preexisting_connections, p2])

func add_bridges():
	for room in $Rooms.get_children():
		_find_connection(room)

func _find_connection(room: Room1) -> bool:
	var room_entrances = []
	var other_entrances = []
	for node in get_tree().get_nodes_in_group("open_entrances"):
		if room.is_a_parent_of(node):
			room_entrances.append(node)
		else:
			other_entrances.append(node)
	
	for p1 in room_entrances:
		p1 = p1 as Position3D
		for p2 in other_entrances:
			p2 = p2 as Position3D
			if _try_connect(p1.global_translation, p2.global_translation):
				p1.remove_from_group("open_entrances")
				p2.remove_from_group("open_entrances")
				
				return true
	return false

func _try_connect(p1: Vector3, p2: Vector3) -> bool:
	var direct_space = get_world().direct_space_state
	var collision = direct_space.intersect_ray(p1, p2)
	
	if collision:
		print(collision.collider)
		
		return false
	else:
		var bridge = Bridge.instance()
		$Bridges.add_child(bridge)
		bridge.init(p1, p2)
		return true
