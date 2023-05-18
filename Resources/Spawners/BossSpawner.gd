extends Spatial

export(Vector3) var position = Vector3(0, 0, -300)

var player = null

onready var spawn_timer = $SpawnTimer as Timer
onready var ghosts = $Ghosts

const Util = preload("res://Resources/Scripts/GeneratorUtil.gd")
const Boss = preload("res://Resources/Entities/Enemies/Boss.tscn")

func init(target):
	player = target

func _physics_process(delta):
	if player.global_translation.distance_to(global_translation) < 100:
#		print("                  %s" % player.global_translation.distance_to(global_translation) < 100)
		var boss = Boss.instance()
		add_child(boss)
		
		boss.init(player, global_translation - Vector3(0, 0, -300))
	else:
		pass
#		print(player.global_translation.distance_to(global_translation) < 100)
