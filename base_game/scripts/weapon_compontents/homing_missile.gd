extends Projectile


var target: Vector3
var movement_type: int


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
	speed = 0.5
	explosive = true
	$Particles.emitting = true
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func _physics_process(_delta):
	translation -= transform.basis.z * speed
	global_transform = global_transform.interpolate_with(\
			global_transform.looking_at(target, Vector3.UP), 0.15)
	if movement_type == ProjectileValues.MovementTypes.STATIC_TARGET:
		target.y -= 0.3
	elif movement_type == ProjectileValues.MovementTypes.DYNAMIC_TARGET:
		target = shooter.global_translation - global_transform.basis.z * 5.0
	else:
		pass


func make_available():
	$Particles.emitting = false
	$AudioStreamPlayer3D.stop()
	get_node("../..").missiles_available.append(self)
