extends KinematicBody
class_name Ghost

export(float) var base_speed := 50
export(float) var chase_speed := 75
export(float) var base_health := 50
export(float) var range_distance_modifier = 200

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

var state = State.IDLE
var player: KinematicBody

var _distance_to_player = INF
var _can_see_player := false

onready var vision = $Eyes/Vision as RayCast
onready var body_mesh = $Body/MainBody.mesh as SphereMesh
onready var _range = $Range.mesh as SphereMesh

enum State {
	IDLE,
	PATROLLING,
	SUSPICIOUS,
	CHASING
}

func _ready():
	var pgroup = $ProximityGroup as ProximityGroup

func init(target, position) -> void:
	player = target as KinematicBody
	global_translation = position

func _physics_process(delta):
	match(state):
		State.IDLE:
			_idle(delta)
		State.PATROLLING:
			_patrol(delta)
		State.SUSPICIOUS:
			_sus(delta)
		State.CHASING:
			_chase(delta)

func _on_StateUpdate_timeout():
	if player:
		_distance_to_player = global_translation.distance_to(player.global_translation)
	else:
		_distance_to_player = INF
		state = State.IDLE
		return
	
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

# Idle behavior
func _idle(delta: float) -> void:
	pass

# Patrol behavior
func _patrol(delta: float) -> void:
	pass


# Sus behavior
func _sus(delta: float) -> void:
	pass

# Chase behavior
func _chase(delta: float) -> void:
	var move_dir = (player.global_translation - global_translation).normalized()
	
	move_and_slide(move_dir * chase_speed, Vector3.UP)
	look_at(player.global_translation, Vector3.UP)
