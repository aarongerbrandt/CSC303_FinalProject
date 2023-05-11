extends Spatial

export(float) var max_stretch = 1.5
const dimensions = Vector3(
	# All dimensions are after scaling by 5
	75.25, # Wall origins are 6.525 away from 0,0 and expand out 1 past that ((6.525 +_1) * 2)
	35, # Tile height is 1, Base Wall height is 4 (scaled 1.5 makes it 6) 
	30.25 # Tile width is 6.05
)

func _ready():
	pass
