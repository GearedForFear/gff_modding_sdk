class_name ArcProjectile
extends Projectile


export var arc_interpolation_base: float = 0.01
export var arc_interpolation_update: float = 1.02

var arc_interpolation: float = 0.01


func _physics_process(_delta):
	translation += transform.basis.z * speed
	global_transform = global_transform.interpolate_with(\
			global_transform.looking_at(global_translation \
			- global_transform.basis.z + Vector3.UP, Vector3.UP), \
			arc_interpolation)
	arc_interpolation *= arc_interpolation_update


func start(global_transform: Transform, damage: float, reward: int, \
		burn: float, shooter: CombatVehicle):
	arc_interpolation = arc_interpolation_base
	.start(global_transform, damage, reward, burn, shooter)
