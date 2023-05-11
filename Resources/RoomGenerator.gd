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

func stop_rooms() -> Array:
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

func add_bridges(points: Array) -> void:
#	print(points)
	for i in range(points.size() - 1):
		var p1 = points[i]
		var p2 = points[i + 1]
		
		var s_p1 = JSON.print(p1)
		var s_p2 = JSON.print(p2)
		
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
