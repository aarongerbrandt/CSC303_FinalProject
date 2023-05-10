extends Spatial

export(int, 1, 50) var min_room_size = 15
export(int, 50, 150) var max_room_size = 20
export(float, 0, 2) var spread_magnitude = 0.25
export(int) var room_height = 20

const Room1 = preload("res://Resources/Rooms/Room1.tscn")
const Bridge = preload("res://Resources/Rooms/Bridge.tscn")

func generate_room(room_position: Vector3) -> void:
	var room_dimensions = Vector3(
		rand_range(min_room_size, max_room_size),
		room_height,
		rand_range(min_room_size, max_room_size)
	)
	
	var room = Room1.instance()
	room.load_position(room_position, room_dimensions)
	$Rooms.add_child(room)

func stop_rooms(points):
	for room in $Rooms.get_children():
		if room:
			# After spreading apart, amplify their distance by a certain threshold
			room.spread(spread_magnitude)
			
			room.mode = RigidBody.MODE_STATIC
			points.append(room.get_center()) # Util.v3_to_v2(room.get_center())

func build_bridges(bridge_points: Array):
	for i in range(bridge_points.size()):
		print("%d: %s" % [i+1, bridge_points[i]])

func create_bridge(p1: Vector3, p2: Vector3) -> void:
	print("test")
	var bridge = Bridge.instance()
	bridge.init(p1, p2)
	
	$Bridges.add_child(bridge)
