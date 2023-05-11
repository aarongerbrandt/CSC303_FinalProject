extends Spatial

export(float) var max_stretch = 1.5
const dimensions = Vector3(
	150.5, # Wall origins are 6.525 away from 0,0 and expand out 1 past that ((6.525 +_1) * 2)
	70, # Tile height is 1, Base Wall height is 4 (scaled 1.5 makes it 6) 
	60.5 # Tile width is 6.05
)

func _ready():
#	print($FloorTile/tileBrickA_large.get_aabb())
#	print($FloorTile2/tileBrickA_large.get_aabb())
#	print($Wall/wall.get_aabb())
#	print($Wall2/wall.get_aabb())
	pass
