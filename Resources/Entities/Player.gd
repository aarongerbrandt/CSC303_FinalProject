extends KinematicBody

export var speed = 100
export var acceleration = 75
export var gravity = 100
export var jump_speed = 75

export var sensitivity = .2

const max_angle = 90
const min_angle = -80

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO

var velocity = Vector3.ZERO

onready var head = $Head as Spatial

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	
	if !is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("Jump"):
		velocity.y = jump_speed
	
	move_dir = Vector3(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		0,
		Input.get_action_strength("Backward") - Input.get_action_strength("Forward")
	).normalized().rotated(Vector3.UP, rotation.y)
	
	velocity.x = lerp(velocity.x, move_dir.x * speed, acceleration * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)
