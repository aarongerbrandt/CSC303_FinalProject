extends Spatial

onready var generator = $LevelGenerator
onready var player = $Player as KinematicBody

func _ready():
	generator.generate()
	generator.connect("level_generated", self, "_on_level_generated")

func _on_level_generated(player_position):
#	print("Recieved Player position: %s" % player_position)
	player.global_translation = player_position
#	$Ghost.init(player, $Ghost.global_translation)
	$GhostSpawner.init(player)

func _input(event):
	if OS.is_debug_build() and event is InputEventKey and event.scancode == KEY_R:
		generator.clear()
		generator.generate()
	
	if event.is_action_pressed("player_action"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
