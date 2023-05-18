extends Spatial

export var particle_lifetime = 2
export var num_particles = 10

onready var particles = $Particles as Particles
onready var particles_done = $ParticlesDone as Timer

func _ready():
	particles.emitting = false
	particles.lifetime = particle_lifetime
	particles.amount = num_particles

func init(position):
	global_translation = position
	particles.emitting = true
	
	particles_done.start(particle_lifetime + 1)


func _on_ParticlesDone_timeout():
	queue_free()
