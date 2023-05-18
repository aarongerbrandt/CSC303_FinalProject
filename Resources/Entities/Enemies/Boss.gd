extends "res://Resources/Entities/Enemies/Ghost.gd"
class_name Boss

func _ready():
	base_health = 1000

func _process(delta):
	state = State.CHASING
	speed = 50
