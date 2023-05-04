extends Spatial

export(int, 1, 50) var number_of_rooms = 25
export(float, 50, 100) var room_placement_radius = 200
export(int, 1, 10) var min_room_size = 5
export(int, 15, 25) var max_room_size = 20

const BEGINNING_HEIGHT = 5

func _ready():
	generate()

func generate():
	randomize()
	for i in range(number_of_rooms):
		var room_position = getRandom3DPointInCircle(room_placement_radius)
		place_room(room_position)

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
	
	var x = radius * r * cos(t)
	var z = radius * r * sin(t)
	
	return Vector3(x, BEGINNING_HEIGHT, z)

func place_room(room_position: Vector3) -> void:
	var room_dimensions = Vector3(
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size),
		rand_range(min_room_size, max_room_size)
	)
	
	var cube = CSGBox.new()
	cube.global_translation = room_position
	cube.scale = room_dimensions
	add_child(cube)
