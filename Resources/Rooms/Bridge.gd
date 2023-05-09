extends StaticBody

var origin: Vector3

func init(p1: Vector3, p2: Vector3) -> void:
	origin = Vector3(
		(p1.x + p2.x) / 2,
		(p1.y + p2.y) / 2,
		(p1.z + p2.z) / 2
	)
	
	# TODO fix bridge spawning
	
	global_translation = origin
	
	$MeshInstance.mesh.size = Vector2(
		p1.distance_to(p2),
		30
	)
