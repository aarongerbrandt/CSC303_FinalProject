extends Spatial
class_name CC_Bullet

export var speed = 100 # 5000
export var lifetime = 30
export var damage = 50

func init(position):
	global_translation = position
	$Timeout.start(lifetime)

func _process(delta):
	translation += global_transform.basis.x * speed * delta

func _destroy():
	queue_free()

func _on_RigidBody_body_entered(body):
	print(body)
	if body.is_in_group("enemies"):
		body.health -= 50
		queue_free()
