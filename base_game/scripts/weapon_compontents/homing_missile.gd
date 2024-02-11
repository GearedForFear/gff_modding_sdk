extends Projectile


var target: Vector3
var moving_target: bool


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	explosive_type = explosive_types.FIRE
	speed = 0.5
	if gles3:
		$Particles.emitting = true
	else:
		$CPUParticles.emitting = true
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func _physics_process(_delta):
	translation += transform.basis.z * speed
	global_transform = global_transform.interpolate_with(\
			global_transform.looking_at(target, Vector3.UP), 0.15)
	if moving_target:
		target = lerp(target, global_transform.origin - target.direction_to(\
				shooter.global_transform.origin), 0.7)
	else:
		target.y += 0.3


func make_available():
	$Particles.emitting = false
	$CPUParticles.emitting = false
	$AudioStreamPlayer3D.stop()
	pools.missiles_available.append(self)
