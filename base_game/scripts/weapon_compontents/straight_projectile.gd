class_name StraightProjectile
extends Projectile


func _physics_process(_delta):
	translation += transform.basis.z * speed
