extends KinematicBody

export(float) var speed := 50
export(float) var health := 50
export(float) var patrol_distance := 75
export(float) var sus_distance := 50
export(float) var chase_distance := 25

var default_mat = SpatialMaterial.new()
var patrol_mat = SpatialMaterial.new()
var sus_mat = SpatialMaterial.new()
var chase_mat = SpatialMaterial.new()

const default_color := Color(0.858824, 0.941176, 0.972549, 0.8)
const patrol_color := Color(0.501961, 0.776471, 0.882353, 0.8)
const sus_color := Color(0.855469, 0.747961, 0.380951, 0.8)
const chase_color := Color(0.901961, 0.545098, 0.505882, 0.8)

const distance_check_time := 1

var state = State.IDLE
var player = null

var _distance_to_player = INF
var _can_see_player := false

onready var vision = $Eyes/Vision as RayCast

enum State {
	IDLE,
	PATROLLING,
	SUSPICIOUS,
	CHASING
}

func _ready():
	var pgroup = $ProximityGroup as ProximityGroup
	
	default_mat.albedo_color = default_color
	patrol_mat.albedo_color = patrol_color
	sus_mat.albedo_color = sus_color
	chase_mat.albedo_color = chase_color
	
	default_mat.flags_transparent = true
	patrol_mat.flags_transparent = true
	sus_mat.flags_transparent = true
	chase_mat.flags_transparent = true

func init(target) -> void:
	player = target

func _physics_process(delta):
	pass

func _on_StateUpdate_timeout():
	if player:
		_distance_to_player = global_translation.distance_to(player.global_translation)
	else:
		_distance_to_player = INF
		state = State.IDLE
		return
	
	var mesh = $Body/MainBody.mesh as SphereMesh
	
	match(state):
		State.IDLE:
			if _distance_to_player < patrol_distance:
				state = State.PATROLLING
				mesh.material = patrol_mat
		State.PATROLLING:
			if _distance_to_player < sus_distance:
				state = State.SUSPICIOUS
				mesh.material = sus_mat
			elif _distance_to_player > patrol_distance:
				state = State.IDLE
				mesh.material = default_mat
		State.SUSPICIOUS:
			if _distance_to_player < chase_distance:
				state = State.CHASING
				mesh.material = chase_mat
			elif _distance_to_player > sus_distance:
				state = State.PATROLLING
				mesh.material = patrol_mat
		State.CHASING:
			if _distance_to_player > chase_distance:
				state = State.SUSPICIOUS
				mesh.material = sus_mat

func can_see_player() -> bool:
	return false
