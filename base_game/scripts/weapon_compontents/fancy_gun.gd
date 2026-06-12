extends Gun


var projectile_material: ShaderMaterial


func shoot(shooter: CombatVehicle) -> Projectile:
	var return_value: Projectile = .shoot(shooter)
	return return_value
