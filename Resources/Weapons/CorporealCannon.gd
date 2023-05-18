extends Spatial

export var shoot_range = 300
export var shoot_rate = 0.8

const Burst = preload("res://Resources/Effects/Burst.tscn")
const Bullet = preload("res://Resources/Weapons/Projectiles/CC_Bullet.tscn")

onready var raycast = $RayCast
onready var animation_player = $AnimationPlayer
onready var bullets = $Bullets

const init_shoot_length := 0.8

func _ready():
	raycast.cast_to = Vector3(0, 0, -shoot_range)
	
	var req_speed = init_shoot_length / shoot_rate
	animation_player.playback_speed = req_speed

func _physics_process(delta):
	fire()

func fire():
	if Input.is_action_pressed("player_action"):
		if !animation_player.is_playing():
			if raycast.is_colliding():
				var burst = Burst.instance()
				get_parent().add_child(burst)
				var hit_pos = raycast.get_collision_point()
				burst.init(hit_pos)
				
				var object_hit = raycast.get_collider()
				if object_hit.is_in_group("enemy"):
					object_hit.health -= 50
		animation_player.play("shoot")
		bullets.restart()
	else:
		animation_player.stop()

#var bullet = Bullet.instance()
#get_node("/root/TestLevel").add_child(bullet)
#
#bullet.init(global_translation)
#bullet.global_transform = 
#print("Added bullet: %s" % bullet)
