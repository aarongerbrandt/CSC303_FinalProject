extends Spatial

export(int) var min_spawn_time_seconds = 3
export(int) var max_spawn_time_seconds = 20
export(int) var min_enemies_in_wave = 1
export(int) var max_enemies_in_wave = 5

export(float) var spawn_radius = 600

var player = null
var is_boss = false

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
	spawn_timer.start(_get_random_time())

func _on_SpawnTimer_timeout():
	spawn_wave()
	spawn_timer.start(_get_random_time())

func spawn_wave():
	if global_translation.distance_to(player.global_translation) < 800:
		var num_enemies_in_wave = round(rand_range(min_enemies_in_wave, max_enemies_in_wave))
		if is_boss:
			print("Spawning %d enemies" % num_enemies_in_wave)
		for i in range(num_enemies_in_wave):
			var spawn_pos = Util.getRandom3DPointInCircle(spawn_radius, 1) + Vector3(0, 100, 0)
			var ghost = Ghost.instance()
			ghosts.add_child(ghost)
			
			ghost.init(player, spawn_pos)
	else:
		if is_boss:
			print("Player out of range: %.2f" % global_translation.distance_to(player.global_translation))
