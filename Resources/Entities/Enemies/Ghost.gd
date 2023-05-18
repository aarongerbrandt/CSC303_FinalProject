extends KinematicBody
class_name Ghost

export(float) var base_speed := 75
export(float) var chase_speed := 100
export(float) var base_health := 50
export(float) var range_distance_modifier = 200

var avg_distance: float

var range_data = {
	State.IDLE: {
		"body": {
			"color": Color(0.858824, 0.941176, 0.972549, 0.8)
		},
		"eye": {
			"color": Color(0.960784, 0.941176, 0.501961),
			"emission": {
				"enabled": false,
			}
		},
		"distance": range_distance_modifier * 4
	},
	State.PATROLLING: {
		"body": {
			"color": Color(0.501961, 0.776471, 0.882353, 0.8)
		},
		"eye": {
			"color": Color(0.960784, 0.941176, 0.501961),
			"emission": {
				"enabled": false
			}
		},
		"distance": range_distance_modifier * 3
	},
	State.SUSPICIOUS: {
		"body": {
			"color": Color(0.855469, 0.747961, 0.380951, 0.8),
		},
		"eye": {
			"color": Color(0.960784, 0.941176, 0.501961),
			"emission": {
				"enabled": true,
				"color": Color(0.909804, 0.062745, 0.062745),
				"energy": 0.5
			},
		},
		"distance": range_distance_modifier * 2
	},
	State.CHASING: {
		"body": {
			"color": Color(0.901961, 0.545098, 0.505882, 0.8),
		},
		"eye": {
			"color": Color(0.960784, 0.941176, 0.501961),
			"emission": {
				"enabled": true,
				"color": Color(0.909804, 0.062745, 0.062745),
				"energy": 0.5
			},
		},
		'distance': range_distance_modifier
	}
}

const distance_check_time := 1
const new_dir_time = 5

var state = State.IDLE
var player: KinematicBody
var speed = base_speed

var _distance_to_player = INF
var _can_see_player := false

onready var _target_location = global_translation

onready var body_mesh = $Body/MainBody.mesh as SphereMesh
onready var _range = $Range.mesh as SphereMesh
onready var new_dir_timer = $PickNewDirection as Timer

enum State {
	IDLE,
	PATROLLING,
	SUSPICIOUS,
	CHASING
}

func init(target, position) -> void:
	player = target as KinematicBody
	global_translation = position
	
	_pick_new_dir()

func _physics_process(delta):
	_move(delta)

func _on_StateUpdate_timeout():
	if player:
		_distance_to_player = global_translation.distance_to(player.global_translation)
	else:
		_distance_to_player = INF
		state = State.IDLE
		return
	
	var _init_state = state
	
	match(state):
		State.IDLE:
			if _distance_to_player < range_data[State.PATROLLING]["distance"]:
				state = State.PATROLLING
				_update_mesh(state)
		State.PATROLLING:
			if _distance_to_player < range_data[State.SUSPICIOUS]["distance"]:
				state = State.SUSPICIOUS
				_update_mesh(state)
			elif _distance_to_player > range_data[State.PATROLLING]["distance"]:
				state = State.IDLE
				_update_mesh(state)
		State.SUSPICIOUS:
			if _distance_to_player < range_data[State.CHASING]["distance"]:
				state = State.CHASING
				_update_mesh(state)
			elif _distance_to_player > range_data[State.SUSPICIOUS]["distance"]:
				state = State.PATROLLING
				_update_mesh(state)
		State.CHASING:
			if _distance_to_player > range_data[State.CHASING]["distance"]:
				state = State.SUSPICIOUS
				_update_mesh(state)
	
	if _init_state != state:
		_pick_new_dir()
	
	_range.radius = range_data[state]["distance"]

func can_see_player() -> bool:
	return false

func _get_body_material(state) -> SpatialMaterial:
	var material = SpatialMaterial.new()
	var body_data = range_data[state]["body"]
	material.albedo_color = body_data["color"]
	material.flags_transparent = true
	
	return material

func _get_eye_material(state) -> SpatialMaterial:
	var mat = SpatialMaterial.new()
	var eye_data = range_data[state]["eye"]
	mat.albedo_color = eye_data["color"]
	if eye_data["emission"]["enabled"]:
		mat.emission = eye_data["emission"]["color"]
		mat.emission_energy = eye_data["emission"]["energy"]
	
	return mat

func _update_mesh(state) -> void:
	$Body/MainBody.mesh.material = _get_body_material(state)
	var eye_material = _get_eye_material(state)
	$Body/Eyes/LeftEye.mesh.material = eye_material
	$Body/Eyes/RightEye.mesh.material = eye_material

func _reached_target(target: Vector3) -> bool:
	return (global_translation.distance_to(target) < 3)

func _move(delta: float):
	if state == State.CHASING:
		_pick_new_dir()
	
	_move_to(_target_location)

func _move_to(target_position: Vector3):
	var move_dir = (target_position - global_translation).normalized()
	if _reached_target(target_position):
		return
	
	var target = move_dir * speed
	
	move_and_slide(target, Vector3.UP)
	look_at(target_position, Vector3.UP)

func _on_PickNewDirection_timeout():
	_pick_new_dir()

func _pick_new_dir():
	var target: Vector3
	
	match(state):
		State.IDLE:
			target = global_translation
		State.PATROLLING:
			speed = base_speed
			target = Util.getRandom3DPointInCircle(300, 1) + global_translation
		State.SUSPICIOUS:
			speed = base_speed
			target = player.global_translation * rand_range(0.75, 1.25)
		State.CHASING:
			speed = chase_speed
			target = player.global_translation
		_:
			return
	_target_location = target
	
	new_dir_timer.start(new_dir_time)
