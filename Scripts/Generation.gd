extends Spatial

export(float) var time_to_room_stop = 10
export(int) var number_of_rooms = 25
export(float) var room_placement_radius = 200
export(int, 1, 10) var min_room_size = 5
export(int, 15, 25) var max_room_size = 20

const Room1 = preload("res://Rooms/Room1.tscn")

const BEGINNING_HEIGHT = 5
const TILE_SIZE = 4

func _ready():
	generate()

func generate():
	randomize()
	for i in range(number_of_rooms):
		var room_position = getRandom3DPointInCircle(room_placement_radius)
		place_room(room_position)
	
	yield(get_tree().create_timer(time_to_room_stop), "timeout")
	_stop_rooms()

func _round(n: float, m: int) -> int:
	return int((n + m - 1) / m) * m

func getRandom3DPointInCircle(radius: float) -> Vector3:
	# Uses algorithm from 
	# gamedeveloper.com/programming/procedural-dungeon-generation-algorithm
	var t = 2 * PI * randf()
	var u = randf() * randf()
	var r = null
	
	if u > 1:
		r = 2 - u
	else:
		r = u
	
	var x = _round(radius * r * cos(t), TILE_SIZE)
	var z = _round(radius * r * sin(t), TILE_SIZE)
	
	return Vector3(x, BEGINNING_HEIGHT, z)

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
	print("Stopping Rooms")
	for room in $Rooms.get_children():
		room.mode = RigidBody.MODE_STATIC
