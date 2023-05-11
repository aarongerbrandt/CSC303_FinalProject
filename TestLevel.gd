extends Spatial

func _ready():
	$LevelGenerator.generate()

func _input(event):
	if OS.is_debug_build() and event is InputEventKey and event.scancode == KEY_R:
		$LevelGenerator.clear()
		$LevelGenerator.generate()
