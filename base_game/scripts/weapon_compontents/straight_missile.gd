extends StraightProjectile


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append(\
				$CPUParticles)
		remove_child($CPUParticles)
	else:
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append(\
				$Particles)
		remove_child($Particles)
		$CPUParticles.name = "Particles"


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	speed = -0.5
	explosive = true
	$Particles.emitting = true
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func make_available():
	$Particles.emitting = false
	$AudioStreamPlayer3D.stop()
	get_node("../..").missiles_available.append(self)
