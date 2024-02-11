extends StraightProjectile


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	explosive_type = explosive_types.FIRE
	speed = 0.5
	if gles3:
		$Particles.emitting = true
	else:
		$CPUParticles.emitting = true
		$CPUParticles.emitting = true
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func make_available():
	$Particles.emitting = false
	$CPUParticles.emitting = false
	$AudioStreamPlayer3D.stop()
	pools.missiles_available.append(self)
