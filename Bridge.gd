extends StaticBody

export var start:Vector3 = Vector3(-1,0,0)
export var end:Vector3 = Vector3(0,0,1)

func _ready():
	build_bridge(start, end)

func build_bridge(p1:Vector3, p2:Vector3):
	var midpoint = (p1 + p2) / 2
	look_at_from_position(midpoint, p1, Vector3.UP)
	var length = (p1 - p2).length()
	set_scale(Vector3(1,1,length / 2))
