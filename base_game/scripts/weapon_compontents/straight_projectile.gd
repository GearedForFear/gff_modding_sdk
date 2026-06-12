class_name StraightProjectile
extends Projectile


func _physics_process(_delta):
	translation += transform.basis.z * speed


func try_deflect(body: PhysicsBody) -> bool:
	shooter = body
	rotation.x += PI
	reset_physics_interpolation()
	return true
