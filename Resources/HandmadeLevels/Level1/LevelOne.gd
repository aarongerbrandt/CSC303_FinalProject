extends Spatial


func init(player):
	for s in $Spawners.get_children():
		s.init(player)
