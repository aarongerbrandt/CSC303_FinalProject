extends Spatial

export(int) var min_spawn_time_seconds = 3
export(int) var max_spawn_time_seconds = 20
export(int) var min_enemies_in_wave = 1
export(int) var max_enemies_in_wave = 5

export(float) var spawn_radius = 50

var player = null

onready var spawn_timer = $SpawnTimer as Timer
onready var ghosts = $Ghosts

const Util = preload("res://Resources/Scripts/GeneratorUtil.gd")
const Ghost = preload("res://Resources/Entities/Enemies/Ghost.tscn")

func _ready():
	randomize()

func _get_random_time() -> int:
	return int(rand_range(min_spawn_time_seconds, max_spawn_time_seconds))

func init(target):
	player = target
	spawn_timer.start()

func _on_SpawnTimer_timeout():
	spawn_wave()

func spawn_wave():
	var num_enemies_in_wave = round(rand_range(min_enemies_in_wave, max_enemies_in_wave))
	
	for i in range(num_enemies_in_wave):
		var spawn_pos = Util.getRandom3DPointInCircle(spawn_radius, 1) + Vector3(0, 100, 0)
		var ghost = Ghost.instance()
		ghosts.add_child(ghost)
		
		ghost.init(player, spawn_pos)
