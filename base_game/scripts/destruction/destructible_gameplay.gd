extends Destructible


func destroy(shooter: CombatVehicle, collision_object_translation_global: Vector3, force: float):
	Pools.get_ammo().start(global_transform, shooter, null, 0)
	.destroy(null, collision_object_translation_global, force)
