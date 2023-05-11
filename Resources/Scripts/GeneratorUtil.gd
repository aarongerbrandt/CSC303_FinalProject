extends Node
class_name Util

static func v3_to_v2(v3: Vector3) -> Vector2:
	return Vector2(v3.x, v3.z)

static func _round(n: float, m: int) -> int:
	return int((n + m - 1) / m) * m

static func getRandom3DPointInCircle(radius: float, tile_size: float) -> Vector3:
	# Uses algorithm from 
	# gamedeveloper.com/programming/procedural-dungeon-generation-algorithm
	var t = 2 * PI * randf()
	var u = randf() + randf()
	var r = null
	
	if u > 1:
		r = 2 - u
	else:
		r = u
	
	var x = _round(radius * r * cos(t), tile_size)
	var z = _round(radius * r * sin(t), tile_size)
	
	return Vector3(x, 0, z)
