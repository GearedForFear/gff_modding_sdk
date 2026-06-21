extends Gun


var projectile_material: ShaderMaterial


func shoot(shooter: CombatVehicle) -> Projectile:
	var return_value: Projectile = .shoot(shooter)
	return_value.get_node("MeshInstance").set_surface_material(0,
			projectile_material)
	return return_value
