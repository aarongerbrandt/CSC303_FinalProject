extends KinematicBody

export var base_speed = 100
export var acceleration = 75
export var gravity = 400
export var jump_speed = 150

const sensitivity = .2
const sprint_modifier = 1.7
const max_angle = 90
const min_angle = -80

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO

const Burst = preload("res://Resources/Effects/Burst.tscn")

onready var head = $Head as Spatial
onready var animation_player = $AnimationPlayer as AnimationPlayer
onready var camera = $Head/Camera as Camera
onready var raycast = $Head/Camera/RayCast as RayCast

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	fire()
	
	_check_for_movement(delta)

func _check_for_movement(delta):
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	velocity.y -= gravity * delta
	
	move_dir = Vector3(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		0,
		Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
	).normalized().rotated(Vector3.UP, rotation.y)
	
	var speed = base_speed * sprint_modifier if Input.is_key_pressed(KEY_SHIFT) else base_speed
	
	velocity.x = lerp(velocity.x, move_dir.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_speed

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

func fire():
	if Input.is_action_pressed("player_action"):
		if !animation_player.is_playing():
			if raycast.is_colliding():
				var burst = Burst.instance()
				add_child(burst)
				var hit_pos = raycast.get_collision_point()
				burst.init(hit_pos)
				
				var object_hit = raycast.get_collider()
				print("Hit: %s" % object_hit)
				if object_hit.is_in_group("enemy"):
					object_hit.health -= 50
		animation_player.play("GunShoot")
	else:
		animation_player.stop()
