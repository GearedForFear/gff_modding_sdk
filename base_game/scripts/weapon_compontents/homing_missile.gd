extends Projectile


var target: Vector3
var movement_type: int


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack($CPUParticles)
		remove_child($CPUParticles)
	else:
		DeletionManager.add_to_stack($Particles)
		remove_child($Particles)
		$CPUParticles.name = "Particles"


func _physics_process(_delta):
	translation -= transform.basis.z * speed
	global_transform = global_transform.interpolate_with(\
			global_transform.looking_at(target, Vector3.UP), 0.15)
	if movement_type == ProjectileValues.MovementTypes.DYNAMIC_TARGET:
		target = shooter.global_translation - global_transform.basis.z * 5.0
	else:
		target.y -= 0.3


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	speed = 0.5
	explosive = true
	$Particles.emitting = true
	$AudioStreamPlayer3D.play()
	.start(global_transform, damage, reward, burn, shooter)


func try_make_available():
	if movement_type == ProjectileValues.MovementTypes.REMOTE:
		shooter.missiles.erase(self)
	.try_make_available()


func make_available():
	$Particles.emitting = false
	$AudioStreamPlayer3D.stop()
	get_node("../..").missiles_available.append(self)
