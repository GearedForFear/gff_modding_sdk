extends Destructible


export(GlobalEnums.PickupTypes) var type
export(int, 1, 1000) var amount: int = 1000


func destroy(shooter: CombatVehicle,
		collision_object_translation_global: Vector3, force: float):
	var spawn_position: Transform = global_transform
	spawn_position.origin.y += 0.7
	PickupFactory.create(spawn_position, shooter, null, type, amount)
	.destroy(null, collision_object_translation_global, force)
