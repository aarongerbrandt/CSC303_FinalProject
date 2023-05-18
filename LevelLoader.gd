extends Spatial

func _ready():
	$GhostSpawner.init($Player)
	$LevelOne.init($Player)
